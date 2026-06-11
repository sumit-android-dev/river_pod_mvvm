import 'package:river_pod_mvvm/src/core/constants/api_constant.dart';
import 'package:river_pod_mvvm/src/patterns/result_pattern.dart';
import 'package:river_pod_mvvm/src/services/http_service.dart';
import 'package:river_pod_mvvm/src/features/auth/exceptions/auth_exception.dart';
import 'package:river_pod_mvvm/src/features/auth/models/auth_model.dart';
import 'package:river_pod_mvvm/src/features/auth/models/user_profile.dart';
import 'package:river_pod_mvvm/src/features/auth/request/sign_in_request.dart';

typedef AuthResult = Result<AuthModel, AuthException>;

abstract interface class AuthRepository {
  Future<AuthResult> login(SignInRequest request);
  Future<Result<UserProfile, AuthException>> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final HttpService httpService;

  AuthRepositoryImpl({
    required this.httpService,
  });

  @override
  Future<AuthResult> login(SignInRequest request) async {
    try {
      final result = await httpService.postData(
        path: ApiConstant.login,
        data: request.toJson(),
      );

      if (result.statusCode == 200 && result.data != null) {
        final authModel =
            AuthModel.fromJson(result.data as Map<String, dynamic>);
        return SuccessResult(value: authModel);
      }

      final errorMessage =
          (result.data as Map<String, dynamic>?)?['message'] ??
          result.error ??
          'Failed to login';
      return ErrorResult(
        error: AuthException(errorMessage),
      );
    } catch (error) {
      return ErrorResult(error: AuthException('Unexpected error: $error'));
    }
  }

  @override
  Future<Result<UserProfile, AuthException>> getCurrentUser() async {
    try {
      final result = await httpService.getData(path: ApiConstant.me);

      if (result.statusCode == 200 && result.data != null) {
        final profile = UserProfile.fromJson(
          result.data as Map<String, dynamic>,
        );
        return SuccessResult(value: profile);
      }

      final errorMessage =
          (result.data as Map<String, dynamic>?)?['message'] ??
          result.error ??
          'Failed to fetch profile';
      return ErrorResult(error: AuthException(errorMessage));
    } catch (error) {
      return ErrorResult(error: AuthException('Unexpected error: $error'));
    }
  }
}
