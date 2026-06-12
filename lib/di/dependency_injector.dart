import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:river_pod_mvvm/services/connection_service.dart';
import 'package:river_pod_mvvm/services/http_service.dart';
import 'package:river_pod_mvvm/services/storage_service.dart';
import 'package:river_pod_mvvm/features/auth/repositories/auth_repository.dart';
import 'package:river_pod_mvvm/features/auth/view_models/auth_view_model.dart';

// Services
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionServiceImpl();
});

final httpServiceProvider = Provider<HttpService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final connectionService = ref.watch(connectionServiceProvider);
  return HttpServiceImpl(
    storageService: storageService,
    connectionService: connectionService,
  );
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageServiceImpl();
});

// Repositories
final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return AuthRepositoryImpl(httpService: httpService);
});

// ViewModels
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

  await Future.wait([
    storageService.initStorage(),
    connectionService.checkConnection(),
  ]);
});
