import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

/// Secure Encrypted Key-Value Storage abstraction using FlutterSecureStorage.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Token Convenience Accessors
  Future<void> saveAccessToken(String token) async => await write(StorageKeys.accessToken, token);
  Future<String?> getAccessToken() async => await read(StorageKeys.accessToken);

  Future<void> saveRefreshToken(String token) async => await write(StorageKeys.refreshToken, token);
  Future<String?> getRefreshToken() async => await read(StorageKeys.refreshToken);

  Future<void> saveSocietyId(String societyId) async => await write(StorageKeys.societyId, societyId);
  Future<String?> getSocietyId() async => await read(StorageKeys.societyId);
}
