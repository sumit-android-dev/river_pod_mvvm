import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:river_pod_mvvm/src/common/constants/api_constant.dart';
import 'package:river_pod_mvvm/src/common/services/storage_service.dart';

typedef HttpResult = ({int? statusCode, Object? data, String? error});

abstract interface class HttpService {
  Future<HttpResult> getData({required String path});
  Future<HttpResult> postData({
    required String path,
    required Map<String, dynamic> data,
  });
}

class HttpServiceImpl implements HttpService {
  final StorageService storageService;
  final _httpClient = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  HttpServiceImpl({required this.storageService}) {
    _httpClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('➡️ Request to: ${options.uri}');
          final token = await storageService.getStringValue(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          debugPrint('❌ Dio error: ${e.message}');

          if (e.response?.statusCode == 401) {
            final success = await _refreshToken();
            if (success) {
              final options = e.requestOptions;
              final token = await storageService.getStringValue(
                key: 'accessToken',
              );
              options.headers['Authorization'] = 'Bearer $token';

              final res = await _httpClient.fetch(options);
              return handler.resolve(res);
            }
          }

          int retryCount = 0;
          int maxRetries = 3;

          while (retryCount < maxRetries &&
              e.type == DioExceptionType.connectionTimeout) {
            retryCount++;
            debugPrint('⏳ Retrying ($retryCount/$maxRetries)...');
            try {
              final res = await _httpClient.request(e.requestOptions.path);
              return handler.resolve(res);
            } catch (_) {}
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await storageService.getStringValue(
        key: 'refreshToken',
      );
      if (refreshToken == null) return false;

      final response = await Dio().post(
        ApiConstant.refresh,
        data: {'refreshToken': refreshToken, 'expiresInMins': 2},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await Future.wait([
          storageService.setStringValue(key: 'accessToken', value: newAccessToken),
          storageService.setStringValue(
            key: 'refreshToken',
            value: newRefreshToken,
          ),
        ]);
        return true;
      }
    } catch (e) {
      debugPrint('❌ Refresh token failed: $e');
    }
    return false;
  }

  HttpResult _handleResponse(Response response) =>
      (statusCode: response.statusCode, data: response.data, error: null);

  HttpResult _handleError(DioException error) => (
    statusCode: error.response?.statusCode,
    data: null,
    error: error.message,
  );

  HttpResult _handleGenericError(Object error) =>
      (statusCode: null, data: null, error: '$error');

  @override
  Future<HttpResult> postData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _httpClient.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  @override
  Future<HttpResult> getData({required String path}) async {
    try {
      final response = await _httpClient.get(path);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }
}
