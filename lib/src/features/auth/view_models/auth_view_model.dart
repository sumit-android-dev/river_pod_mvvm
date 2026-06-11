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
  UserProfile? get userProfile;
  Future<void> login();
  Future<void> logout();
  (bool, String) canSendSignInRequest();
  Future<bool> isLogin();
  Future<void> getProfile();
}

class AuthViewModelImpl extends _ViewModel implements AuthViewModel {
  final AuthRepository authRepository;
  final StorageService storageService;

  @override
  final SignInRequest signInRequest = SignInRequest();

  @override
  UserProfile? userProfile;

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
      userProfile = UserProfile(
        id: result.value.id,
        username: result.value.username,
        email: result.value.email,
        firstName: result.value.firstName,
        lastName: result.value.lastName,
        gender: result.value.gender,
        image: result.value.image,
      );
      await Future.wait([
        storageService.setStringValue(
          key: 'accessToken',
          value: result.value.accessToken,
        ),
        storageService.setStringValue(
          key: 'refreshToken',
          value: result.value.refreshToken,
        ),
      ]);
      emitState(SuccessState(data: result.value));
    } else if (result is ErrorResult<AuthModel, AuthException>) {
      emitState(ErrorState(error: result.error));
    }
  }

  @override
  Future<void> logout() async {
    userProfile = null;
    await Future.wait([
      storageService.removeValue(key: 'accessToken'),
      storageService.removeValue(key: 'refreshToken'),
    ]);
    emitState(const InitialState());
  }

  @override
  Future<bool> isLogin() async {
    final token = await storageService.getStringValue(key: 'accessToken');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> getProfile() async {
    final result = await authRepository.getCurrentUser();
    if (result is SuccessResult<UserProfile, AuthException>) {
      userProfile = result.value;
      notifyListeners();
    }
  }
}
