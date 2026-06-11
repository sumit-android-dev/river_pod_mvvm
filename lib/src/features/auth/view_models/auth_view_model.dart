import 'package:flutter/foundation.dart';
import 'package:river_pod_mvvm/src/common/patterns/app_state_pattern.dart';
import 'package:river_pod_mvvm/src/common/patterns/result_pattern.dart';
import 'package:river_pod_mvvm/src/common/state_management/state_management.dart';
import 'package:river_pod_mvvm/src/features/auth/exceptions/auth_exception.dart';
import 'package:river_pod_mvvm/src/features/auth/models/auth_model.dart';
import 'package:river_pod_mvvm/src/features/auth/repositories/auth_repository.dart';
import 'package:river_pod_mvvm/src/common/services/storage_service.dart';

typedef AuthState = AppState<AuthModel, AuthException>;

typedef _ViewModel = StateManagement<AuthState>;

abstract interface class AuthViewModel extends _ViewModel {
  SignInRequest get signInRequest;
  Future<void> login();
  Future<void> logout();
  (bool, String) canSendSignInRequest();
  Future<bool> isLogin();
}

class AuthViewModelImpl extends _ViewModel implements AuthViewModel {
  final AuthRepository authRepository;
  final StorageService storageService;

  @override
  final SignInRequest signInRequest = SignInRequest();

  AuthViewModelImpl({
    required this.authRepository,
    required this.storageService,
  });

  @override
  AuthState build() => const InitialState();

  @override
  (bool, String) canSendSignInRequest() {
    if (signInRequest.username.isEmpty) {
      return (false, 'Username is required');
    }
    if (signInRequest.password.isEmpty) {
      return (false, 'Password is required');
    }
    return (true, '');
  }

  @override
  Future<void> login() async {
    emitState(const LoadingState());

    final result = await authRepository.login(signInRequest);

    if (result is SuccessResult<AuthModel, AuthException>) {
      await storageService.setStringValue(
        key: 'token',
        value: result.value.accessToken,
      );
      emitState(SuccessState(data: result.value));
    } else if (result is ErrorResult<AuthModel, AuthException>) {
      emitState(ErrorState(error: result.error));
    }
  }

  @override
  Future<void> logout() async {
    await storageService.removeValue(key: 'token');
    emitState(const InitialState());
  }

  @override
  Future<bool> isLogin() async {
    final token = await storageService.getStringValue(key: 'token');
    return token != null && token.isNotEmpty;
  }
}
