import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nivaas_mobile/core/network/network_info.dart';
import 'package:nivaas_mobile/features/resident/domain/entities/emergency_contact.dart';
import 'package:nivaas_mobile/features/resident/domain/entities/family_member.dart';
import 'package:nivaas_mobile/features/resident/domain/entities/house_detail.dart';
import 'package:nivaas_mobile/features/resident/domain/entities/resident_profile.dart';
import 'package:nivaas_mobile/features/resident/domain/entities/resident_vehicle.dart';
import 'package:nivaas_mobile/features/resident/domain/entities/society_info.dart';
import 'package:nivaas_mobile/features/resident/data/repositories/resident_repository_impl.dart';
import 'package:nivaas_mobile/features/resident/data/datasources/resident_remote_datasource.dart';
import 'package:nivaas_mobile/features/resident/data/datasources/resident_local_datasource.dart';

class MockNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Stream.value([ConnectivityResult.wifi]);
}

class MockResidentRemoteDataSource implements ResidentRemoteDataSource {
  @override
  Future<ResidentProfile> getResidentProfile() async {
    return const ResidentProfile(
      id: 'res_101',
      phone: '+91 9876543210',
      fullName: 'Priya Nair',
      email: 'priya.nair@example.com',
      role: 'OWNER',
    );
  }

  @override
  Future<ResidentProfile> updateResidentProfile(ResidentProfile profile) async => profile;

  @override
  Future<HouseDetail> getHouseDetail() async {
    return const HouseDetail(
      houseId: 'house_402',
      flatNumber: '402',
      wingName: 'Wing A',
      floorNumber: 4,
      houseType: '3BHK',
      ownershipStatus: 'OWNER',
      maintenanceCategory: 'STANDARD',
      societyName: 'Green Park Apartments RWA',
    );
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() async {
    return [
      const FamilyMember(id: 'fam_1', name: 'Rohan Nair', relationship: 'Spouse'),
    ];
  }

  @override
  Future<FamilyMember> addFamilyMember(FamilyMember member) async => member;

  @override
  Future<List<ResidentVehicle>> getVehicles() async {
    return [
      const ResidentVehicle(id: 'veh_1', vehicleNumber: 'DL 01 AB 1234', vehicleType: 'FOUR_WHEELER'),
    ];
  }

  @override
  Future<ResidentVehicle> addVehicle(ResidentVehicle vehicle) async => vehicle;

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    return [
      const EmergencyContact(id: 'ec_1', designation: 'Main Gate Security', name: 'Security Desk', phone: '+91 11 2800 0001', category: 'SECURITY'),
    ];
  }

  @override
  Future<SocietyInfo> getSocietyInfo() async {
    return const SocietyInfo(
      id: 'soc_001',
      name: 'Green Park Apartments RWA',
      address: 'Sector 12, Dwarka',
      officeContact: '+91 11 2800 0002',
      officeTiming: '09:00 AM - 06:00 PM',
    );
  }
}

class MockResidentLocalDataSource implements ResidentLocalDataSource {
  ResidentProfile? _cachedProfile;
  HouseDetail? _cachedHouse;
  List<FamilyMember>? _cachedFamily;
  List<ResidentVehicle>? _cachedVehicles;
  List<EmergencyContact>? _cachedContacts;
  SocietyInfo? _cachedSociety;

  @override
  Future<void> cacheResidentProfile(ResidentProfile profile) async => _cachedProfile = profile;
  @override
  Future<ResidentProfile?> getCachedResidentProfile() async => _cachedProfile;

  @override
  Future<void> cacheHouseDetail(HouseDetail house) async => _cachedHouse = house;
  @override
  Future<HouseDetail?> getCachedHouseDetail() async => _cachedHouse;

  @override
  Future<void> cacheFamilyMembers(List<FamilyMember> members) async => _cachedFamily = members;
  @override
  Future<List<FamilyMember>?> getCachedFamilyMembers() async => _cachedFamily;

  @override
  Future<void> cacheVehicles(List<ResidentVehicle> vehicles) async => _cachedVehicles = vehicles;
  @override
  Future<List<ResidentVehicle>?> getCachedVehicles() async => _cachedVehicles;

  @override
  Future<void> cacheEmergencyContacts(List<EmergencyContact> contacts) async => _cachedContacts = contacts;
  @override
  Future<List<EmergencyContact>?> getCachedEmergencyContacts() async => _cachedContacts;

  @override
  Future<void> cacheSocietyInfo(SocietyInfo info) async => _cachedSociety = info;
  @override
  Future<SocietyInfo?> getCachedSocietyInfo() async => _cachedSociety;
}

void main() {
  late ResidentRepositoryImpl repository;
  late MockResidentRemoteDataSource remoteDS;
  late MockResidentLocalDataSource localDS;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDS = MockResidentRemoteDataSource();
    localDS = MockResidentLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = ResidentRepositoryImpl(
      remoteDataSource: remoteDS,
      localDataSource: localDS,
      networkInfo: networkInfo,
      isDevelopment: true,
    );
  });

  group('Phase 04 Resident Module Unit Tests', () {
    test('Resident profile deserialization and props equality', () {
      const profile = ResidentProfile(
        id: 'res_101',
        phone: '+91 9876543210',
        fullName: 'Priya Nair',
        role: 'OWNER',
      );
      expect(profile.fullName, equals('Priya Nair'));
      expect(profile.role, equals('OWNER'));
    });

    test('House detail fetches correctly in repository', () async {
      final house = await repository.getHouseDetail();
      expect(house.flatNumber, equals('402'));
    });

    test('Family member addition updates local cache and repository', () async {
      const newMember = FamilyMember(id: 'fam_99', name: 'Aarav Nair', relationship: 'Son');
      final added = await repository.addFamilyMember(newMember);
      expect(added.name, equals('Aarav Nair'));

      final members = await repository.getFamilyMembers();
      expect(members.any((m) => m.name == 'Aarav Nair'), isTrue);
    });

    test('Vehicle addition updates vehicle registry', () async {
      const newVehicle = ResidentVehicle(id: 'veh_99', vehicleNumber: 'DL 01 EV 9999', vehicleType: 'ELECTRIC');
      final added = await repository.addVehicle(newVehicle);
      expect(added.vehicleNumber, equals('DL 01 EV 9999'));

      final vehicles = await repository.getVehicles();
      expect(vehicles.any((v) => v.vehicleNumber == 'DL 01 EV 9999'), isTrue);
    });

    test('Emergency contacts directory retrieval works', () async {
      final contacts = await repository.getEmergencyContacts();
      expect(contacts.isNotEmpty, isTrue);
    });

    test('Society Info retrieval works', () async {
      final info = await repository.getSocietyInfo();
      expect(info.name, contains('Green Park'));
    });
  });
}
