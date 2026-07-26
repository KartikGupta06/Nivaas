import 'dart:convert';
import '../../../../core/security/secure_storage_service.dart';
import '../../domain/entities/user_profile.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserProfile(UserProfile profile);
  Future<UserProfile?> getUserProfile();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _keyUserProfile = 'nivaas_user_profile_data';
  final SecureStorageService _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final jsonString = json.encode(profile.toJson());
    await _secureStorage.write(_keyUserProfile, jsonString);
    if (profile.societyId != null) {
      await _secureStorage.saveSocietyId(profile.societyId!);
    }
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    final jsonString = await _secureStorage.read(_keyUserProfile);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await _secureStorage.clearAll();
  }
}
