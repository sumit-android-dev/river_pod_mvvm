import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:river_pod_mvvm/core/constants/value_constant.dart';

abstract interface class SecureStorageService {
  Future<void> setAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> setRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteTokens();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  Future<void> setAccessToken(String token) async {
    try {
      await _storage.write(key: ValueConstant.accessToken, value: token);
    } catch (error) {
      throw Exception('SecureStorageService: $error');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: ValueConstant.accessToken);
    } catch (error) {
      throw Exception('SecureStorageService: $error');
    }
  }

  @override
  Future<void> setRefreshToken(String token) async {
    try {
      await _storage.write(key: ValueConstant.refreshToken, value: token);
    } catch (error) {
      throw Exception('SecureStorageService: $error');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: ValueConstant.refreshToken);
    } catch (error) {
      throw Exception('SecureStorageService: $error');
    }
  }

  @override
  Future<void> deleteTokens() async {
    try {
      await _storage.delete(key: ValueConstant.accessToken);
      await _storage.delete(key: ValueConstant.refreshToken);
    } catch (error) {
      throw Exception('SecureStorageService: $error');
    }
  }
}
