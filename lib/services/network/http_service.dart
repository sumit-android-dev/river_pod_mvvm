import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:river_pod_mvvm/common/enums/http_error_enum.dart';
import 'package:river_pod_mvvm/core/constants/api_constant.dart';
import 'package:river_pod_mvvm/services/local_db/secure_storage_service.dart';
import 'package:river_pod_mvvm/services/network/connection_service.dart';

typedef HttpResult = ({int? statusCode, Object? data, String? error, HttpError? errorType});

abstract interface class HttpService {
  Future<HttpResult> getData({required String path, Map<String, dynamic>? queryParameters});

  Future<HttpResult> postData({required String path, required Map<String, dynamic> data});

  Future<HttpResult> putData({required String path, required Map<String, dynamic> data});
}

class HttpServiceImpl implements HttpService {
  final SecureStorageService secureStorageService;
  final ConnectionService connectionService;

  late final Dio _httpClient;

  Future<bool>? _refreshFuture;

  HttpServiceImpl({required this.secureStorageService, required this.connectionService}) {
    _httpClient = Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (kDebugMode) {
      _httpClient.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    _httpClient.interceptors.add(InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
  }

  /// REQUEST
  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await connectionService.checkConnection();
    if (!connectionService.isConnected) {
      return handler.reject(DioException(requestOptions: options, error: 'No internet connection', type: DioExceptionType.connectionError));
    }

    final token = await secureStorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  /// RESPONSE
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// ERROR
  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    final statusCode = error.response?.statusCode;

    /// Refresh Token Flow
    if (statusCode == HttpError.unauthorized.statusCode) {
      final success = await _refreshTokenIfNeeded();

      if (success) {
        try {
          final requestOptions = error.requestOptions;

          final token = await secureStorageService.getAccessToken();

          requestOptions.headers['Authorization'] = 'Bearer $token';

          final response = await _httpClient.fetch(requestOptions);

          return handler.resolve(response);
        } catch (_) {}
      }
    }

    /// Retry Flow
    final retryCount = (error.requestOptions.extra['retryCount'] as int?) ?? 0;
    const maxRetries = 2;

    if (_shouldRetry(error) && retryCount < maxRetries) {
      try {
        error.requestOptions.extra['retryCount'] = retryCount + 1;
        final response = await _httpClient.fetch(error.requestOptions);

        return handler.resolve(response);
      } catch (_) {}
    }

    return handler.next(error);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.connectionError;
  }

  /// REFRESH TOKEN
  Future<bool> _refreshTokenIfNeeded() {
    _refreshFuture ??= _refreshToken();

    return _refreshFuture!.whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await secureStorageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await Dio().post(ApiConstant.refresh, data: {'refreshToken': refreshToken, 'expiresInMins': 2});

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];

        final newRefreshToken = response.data['refreshToken'];

        await Future.wait([secureStorageService.setAccessToken(accessToken), secureStorageService.setRefreshToken(newRefreshToken)]);

        return true;
      }
    } catch (e) {
      debugPrint('Refresh token failed: $e');
    }
    return false;
  }

  /// RESULT MAPPERS
  HttpResult _handleResponse(Response response) {
    return (statusCode: response.statusCode, data: response.data, error: null, errorType: null);
  }

  HttpResult _handleError(DioException error) {
    String message = error.message ?? 'Something went wrong';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Server response timeout';
        break;

      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;

      case DioExceptionType.badResponse:
        if (error.response?.data is Map) {
          message = error.response?.data['message'] ?? message;
        }
        break;

      default:
        break;
    }

    return (statusCode: error.response?.statusCode, data: error.response?.data, error: message, errorType: HttpError.fromStatusCode(error.response?.statusCode));
  }

  HttpResult _handleGenericError(Object error) {
    return (statusCode: null, data: null, error: error.toString(), errorType: HttpError.unknown);
  }

  /// GET
  @override
  Future<HttpResult> getData({required String path, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _httpClient.get(path, queryParameters: queryParameters);

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  /// POST
  @override
  Future<HttpResult> postData({required String path, required Map<String, dynamic> data}) async {
    try {
      final response = await _httpClient.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  /// PUT
  @override
  Future<HttpResult> putData({required String path, required Map<String, dynamic> data}) async {
    try {
      final response = await _httpClient.put(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }
}
