import 'dart:convert';
import '../../../../core/security/secure_storage_service.dart';

abstract class SocietySetupLocalDataSource {
  Future<void> saveDraft(Map<String, dynamic> draftData);
  Future<Map<String, dynamic>?> getDraft();
  Future<void> clearDraft();
}

class SocietySetupLocalDataSourceImpl implements SocietySetupLocalDataSource {
  static const String _keySetupDraft = 'nivaas_society_setup_draft_v1';
  final SecureStorageService _secureStorage;

  SocietySetupLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveDraft(Map<String, dynamic> draftData) async {
    final jsonStr = json.encode(draftData);
    await _secureStorage.write(_keySetupDraft, jsonStr);
  }

  @override
  Future<Map<String, dynamic>?> getDraft() async {
    final jsonStr = await _secureStorage.read(_keySetupDraft);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearDraft() async {
    await _secureStorage.delete(_keySetupDraft);
  }
}
