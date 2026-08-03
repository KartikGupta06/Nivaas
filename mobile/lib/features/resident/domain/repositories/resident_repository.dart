import '../entities/resident_profile.dart';
import '../entities/house_detail.dart';
import '../entities/family_member.dart';
import '../entities/resident_vehicle.dart';
import '../entities/emergency_contact.dart';
import '../entities/society_info.dart';

abstract class ResidentRepository {
  Future<ResidentProfile> getResidentProfile();
  Future<HouseDetail> getHouseDetail();
  Future<List<FamilyMember>> getFamilyMembers();
  Future<List<ResidentVehicle>> getVehicles();
  Future<List<EmergencyContact>> getEmergencyContacts();
  Future<SocietyInfo> getSocietyInfo();
}

abstract class ProfileRepository {
  Future<ResidentProfile> getProfile();
  Future<ResidentProfile> updateProfile(ResidentProfile profile);
}

abstract class HouseRepository {
  Future<HouseDetail> getHouseDetail();
}

abstract class VehicleRepository {
  Future<List<ResidentVehicle>> getVehicles();
  Future<ResidentVehicle> addVehicle(ResidentVehicle vehicle);
}

abstract class FamilyRepository {
  Future<List<FamilyMember>> getFamilyMembers();
  Future<FamilyMember> addFamilyMember(FamilyMember member);
}

abstract class EmergencyContactRepository {
  Future<List<EmergencyContact>> getEmergencyContacts();
}

abstract class SocietyInfoRepository {
  Future<SocietyInfo> getSocietyInfo();
}
