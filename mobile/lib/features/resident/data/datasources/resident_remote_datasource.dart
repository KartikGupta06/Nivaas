import '../../../../core/network/api_client.dart';
import '../../domain/entities/resident_profile.dart';
import '../../domain/entities/house_detail.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/resident_vehicle.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/entities/society_info.dart';

abstract class ResidentRemoteDataSource {
  Future<ResidentProfile> getResidentProfile();
  Future<ResidentProfile> updateResidentProfile(ResidentProfile profile);
  Future<HouseDetail> getHouseDetail();
  Future<List<FamilyMember>> getFamilyMembers();
  Future<FamilyMember> addFamilyMember(FamilyMember member);
  Future<List<ResidentVehicle>> getVehicles();
  Future<ResidentVehicle> addVehicle(ResidentVehicle vehicle);
  Future<List<EmergencyContact>> getEmergencyContacts();
  Future<SocietyInfo> getSocietyInfo();
}

class ResidentRemoteDataSourceImpl implements ResidentRemoteDataSource {
  final ApiClient apiClient;

  ResidentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ResidentProfile> getResidentProfile() async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/resident/profile');
    if (response.data != null) {
      return ResidentProfile.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<ResidentProfile> updateResidentProfile(ResidentProfile profile) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/api/v1/resident/profile',
      data: profile.toJson(),
    );
    if (response.data != null) {
      return ResidentProfile.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<HouseDetail> getHouseDetail() async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/resident/house');
    if (response.data != null) {
      return HouseDetail.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() async {
    final response = await apiClient.get<List<dynamic>>('/api/v1/resident/family');
    if (response.data != null) {
      return response.data!
          .map((item) => FamilyMember.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<FamilyMember> addFamilyMember(FamilyMember member) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/v1/resident/family',
      data: member.toJson(),
    );
    if (response.data != null) {
      return FamilyMember.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<List<ResidentVehicle>> getVehicles() async {
    final response = await apiClient.get<List<dynamic>>('/api/v1/resident/vehicles');
    if (response.data != null) {
      return response.data!
          .map((item) => ResidentVehicle.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ResidentVehicle> addVehicle(ResidentVehicle vehicle) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/v1/resident/vehicles',
      data: vehicle.toJson(),
    );
    if (response.data != null) {
      return ResidentVehicle.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    final response = await apiClient.get<List<dynamic>>('/api/v1/resident/emergency-contacts');
    if (response.data != null) {
      return response.data!
          .map((item) => EmergencyContact.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<SocietyInfo> getSocietyInfo() async {
    final response = await apiClient.get<Map<String, dynamic>>('/api/v1/resident/society');
    if (response.data != null) {
      return SocietyInfo.fromJson(response.data!);
    }
    throw Exception('Empty response payload');
  }
}
