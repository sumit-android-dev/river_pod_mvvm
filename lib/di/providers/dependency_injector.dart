import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:river_pod_mvvm/services/network/connection_service.dart';
import 'package:river_pod_mvvm/services/network/http_service.dart';
import 'package:river_pod_mvvm/services/local_db/storage_service.dart';
import 'package:river_pod_mvvm/services/local_db/secure_storage_service.dart';
import 'package:river_pod_mvvm/features/auth/repositories/auth_repository.dart';
import 'package:river_pod_mvvm/features/auth/view_models/auth_view_model.dart';

// Services
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionServiceImpl();
});

final httpServiceProvider = Provider<HttpService>((ref) {
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  final connectionService = ref.watch(connectionServiceProvider);
  return HttpServiceImpl(
    secureStorageService: secureStorageService,
    connectionService: connectionService,
  );
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageServiceImpl();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl();
});

// Repositories
final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return AuthRepositoryImpl(httpService: httpService);
});

// ViewModels
final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  return AuthViewModelImpl(
    authRepository: authRepository,
    secureStorageService: secureStorageService,
  );
});

/// Init dependencies asynchronously.
final appFutureProvider = FutureProvider<void>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  final connectionService = ref.read(connectionServiceProvider);

  await Future.wait([
    storageService.initStorage(),
    connectionService.checkConnection(),
  ]);
});
