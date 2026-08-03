import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/resident_profile.dart';
import '../../domain/entities/house_detail.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/resident_vehicle.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/entities/society_info.dart';

abstract class ResidentLocalDataSource {
  Future<void> cacheResidentProfile(ResidentProfile profile);
  Future<ResidentProfile?> getCachedResidentProfile();

  Future<void> cacheHouseDetail(HouseDetail house);
  Future<HouseDetail?> getCachedHouseDetail();

  Future<void> cacheFamilyMembers(List<FamilyMember> members);
  Future<List<FamilyMember>?> getCachedFamilyMembers();

  Future<void> cacheVehicles(List<ResidentVehicle> vehicles);
  Future<List<ResidentVehicle>?> getCachedVehicles();

  Future<void> cacheEmergencyContacts(List<EmergencyContact> contacts);
  Future<List<EmergencyContact>?> getCachedEmergencyContacts();

  Future<void> cacheSocietyInfo(SocietyInfo info);
  Future<SocietyInfo?> getCachedSocietyInfo();
}

class ResidentLocalDataSourceImpl implements ResidentLocalDataSource {
  static const String _profileKey = 'cached_resident_profile';
  static const String _houseKey = 'cached_house_detail';
  static const String _familyKey = 'cached_family_members';
  static const String _vehiclesKey = 'cached_resident_vehicles';
  static const String _emergencyKey = 'cached_emergency_contacts';
  static const String _societyKey = 'cached_society_info';

  SharedPreferences? _prefs;

  ResidentLocalDataSourceImpl({SharedPreferences? sharedPreferences}) : _prefs = sharedPreferences;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> cacheResidentProfile(ResidentProfile profile) async {
    final prefs = await _getPrefs();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<ResidentProfile?> getCachedResidentProfile() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_profileKey);
    if (raw != null) {
      try {
        return ResidentProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheHouseDetail(HouseDetail house) async {
    final prefs = await _getPrefs();
    await prefs.setString(_houseKey, jsonEncode(house.toJson()));
  }

  @override
  Future<HouseDetail?> getCachedHouseDetail() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_houseKey);
    if (raw != null) {
      try {
        return HouseDetail.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheFamilyMembers(List<FamilyMember> members) async {
    final prefs = await _getPrefs();
    final list = members.map((m) => m.toJson()).toList();
    await prefs.setString(_familyKey, jsonEncode(list));
  }

  @override
  Future<List<FamilyMember>?> getCachedFamilyMembers() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_familyKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheVehicles(List<ResidentVehicle> vehicles) async {
    final prefs = await _getPrefs();
    final list = vehicles.map((v) => v.toJson()).toList();
    await prefs.setString(_vehiclesKey, jsonEncode(list));
  }

  @override
  Future<List<ResidentVehicle>?> getCachedVehicles() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_vehiclesKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((e) => ResidentVehicle.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheEmergencyContacts(List<EmergencyContact> contacts) async {
    final prefs = await _getPrefs();
    final list = contacts.map((c) => c.toJson()).toList();
    await prefs.setString(_emergencyKey, jsonEncode(list));
  }

  @override
  Future<List<EmergencyContact>?> getCachedEmergencyContacts() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_emergencyKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheSocietyInfo(SocietyInfo info) async {
    final prefs = await _getPrefs();
    await prefs.setString(_societyKey, jsonEncode(info.toJson()));
  }

  @override
  Future<SocietyInfo?> getCachedSocietyInfo() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_societyKey);
    if (raw != null) {
      try {
        return SocietyInfo.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
