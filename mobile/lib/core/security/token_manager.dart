import 'secure_storage_service.dart';

/// Token Lifecycle Manager supervising JWT storage, validation, and clearance.
class TokenManager {
  final SecureStorageService _secureStorage;

  TokenManager(this._secureStorage);

  Future<bool> hasValidToken() async {
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveAuthTokens({required String accessToken, required String refreshToken}) async {
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
  }

  Future<void> clearAuthSession() async {
    await _secureStorage.clearAll();
  }
}
