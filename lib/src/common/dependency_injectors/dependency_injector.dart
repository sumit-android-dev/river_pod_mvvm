import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:river_pod_mvvm/src/common/services/connection_service.dart';
import 'package:river_pod_mvvm/src/common/services/http_service.dart';
import 'package:river_pod_mvvm/src/common/services/storage_service.dart';
import 'package:river_pod_mvvm/src/features/auth/repositories/auth_repository.dart';
import 'package:river_pod_mvvm/src/features/auth/view_models/auth_view_model.dart';
import 'package:river_pod_mvvm/src/features/settings/repositories/setting_repository.dart';
import 'package:river_pod_mvvm/src/features/settings/view_models/setting_view_model.dart';

// Services
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionServiceImpl();
});

final httpServiceProvider = Provider<HttpService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return HttpServiceImpl(storageService: storageService);
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageServiceImpl();
});

// Repositories
final settingRepositoryProvider = Provider.autoDispose<SettingRepository>((
  ref,
) {
  final storageService = ref.watch(storageServiceProvider);
  return SettingRepositoryImpl(storageService: storageService);
});

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final connectionService = ref.watch(connectionServiceProvider);
  final httpService = ref.watch(httpServiceProvider);
  return AuthRepositoryImpl(
    connectionService: connectionService,
    httpService: httpService,
  );
});

// ViewModels
final settingViewModelProvider = ChangeNotifierProvider<SettingViewModel>((
  ref,
) {
  final settingRepository = ref.watch(settingRepositoryProvider);
  return SettingViewModelImpl(settingRepository: settingRepository);
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthViewModelImpl(
    authRepository: authRepository,
    storageService: storageService,
  );
});

/// Init dependencies asynchronously.
final appFutureProvider = FutureProvider<void>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  final connectionService = ref.read(connectionServiceProvider);
  final settingViewModel = ref.read(settingViewModelProvider);

  await Future.wait([
    storageService.initStorage(),
    connectionService.checkConnection(),
  ]);

  await settingViewModel.getTheme();
});
