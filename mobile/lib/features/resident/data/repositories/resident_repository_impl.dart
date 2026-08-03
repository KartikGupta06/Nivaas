import '../../../../core/network/network_info.dart';
import '../../domain/entities/resident_profile.dart';
import '../../domain/entities/house_detail.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/resident_vehicle.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/entities/society_info.dart';
import '../../domain/repositories/resident_repository.dart';
import '../datasources/resident_remote_datasource.dart';
import '../datasources/resident_local_datasource.dart';

class ResidentRepositoryImpl
    implements
        ResidentRepository,
        ProfileRepository,
        HouseRepository,
        VehicleRepository,
        FamilyRepository,
        EmergencyContactRepository,
        SocietyInfoRepository {
  final ResidentRemoteDataSource remoteDataSource;
  final ResidentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final bool isDevelopment;

  ResidentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    this.isDevelopment = true,
  });

  // Mock dev data fallbacks
  static const ResidentProfile _mockProfile = ResidentProfile(
    id: 'res_101',
    phone: '+91 9876543210',
    fullName: 'Priya Nair',
    email: 'priya.nair@example.com',
    role: 'OWNER',
    emergencyContact: '+91 9876500000',
    fullAddress: 'Flat A-402, Green Park Apartments, Sector 12, Dwarka, New Delhi',
    avatarUrl: null,
    houseAssignment: 'Wing A - Flat 402',
  );

  static const HouseDetail _mockHouse = HouseDetail(
    houseId: 'house_402',
    flatNumber: '402',
    wingName: 'Wing A',
    floorNumber: 4,
    houseType: '3BHK',
    areaSqFt: 1450.0,
    ownershipStatus: 'OWNER',
    maintenanceCategory: 'STANDARD',
    parkingSlot: 'P1-A402',
    societyName: 'Green Park Apartments RWA',
    moveInDate: '15 Jan 2024',
  );

  static const List<FamilyMember> _mockFamily = [
    FamilyMember(
      id: 'fam_1',
      name: 'Rohan Nair',
      relationship: 'Spouse',
      role: 'Owner',
      contactNumber: '+91 9876543211',
      isChild: false,
      isSeniorCitizen: false,
    ),
    FamilyMember(
      id: 'fam_2',
      name: 'Aarav Nair',
      relationship: 'Son',
      role: 'Children',
      contactNumber: null,
      isChild: true,
      isSeniorCitizen: false,
    ),
  ];

  static const List<ResidentVehicle> _mockVehicles = [
    ResidentVehicle(
      id: 'veh_1',
      vehicleNumber: 'DL 01 AB 1234',
      vehicleType: 'FOUR_WHEELER',
      parkingSlot: 'P1-A402',
      stickerNumber: 'STK-2026-091',
      status: 'ACTIVE',
    ),
    ResidentVehicle(
      id: 'veh_2',
      vehicleNumber: 'DL 01 XY 5678',
      vehicleType: 'TWO_WHEELER',
      parkingSlot: 'P2-A402',
      stickerNumber: 'STK-2026-092',
      status: 'ACTIVE',
    ),
  ];

  static const List<EmergencyContact> _mockEmergencyContacts = [
    EmergencyContact(
      id: 'ec_1',
      designation: 'Main Gate Security',
      name: 'Security Desk',
      phone: '+91 11 2800 0001',
      category: 'SECURITY',
      iconName: 'security',
    ),
    EmergencyContact(
      id: 'ec_2',
      designation: 'Society Admin Office',
      name: 'Manager Office',
      phone: '+91 11 2800 0002',
      category: 'OFFICE',
      iconName: 'business',
    ),
    EmergencyContact(
      id: 'ec_3',
      designation: 'Society Electrician',
      name: 'Ramesh Kumar',
      phone: '+91 98111 22334',
      category: 'ELECTRICIAN',
      iconName: 'bolt',
    ),
    EmergencyContact(
      id: 'ec_4',
      designation: 'Society Plumber',
      name: 'Suresh Verma',
      phone: '+91 98222 33445',
      category: 'PLUMBER',
      iconName: 'water_drop',
    ),
    EmergencyContact(
      id: 'ec_5',
      designation: 'Fire Control Room',
      name: 'Fire Station Dwarka',
      phone: '101',
      category: 'FIRE',
      iconName: 'local_fire_department',
    ),
    EmergencyContact(
      id: 'ec_6',
      designation: 'Emergency Ambulance',
      name: 'Max Hospital Ambulance',
      phone: '102',
      category: 'AMBULANCE',
      iconName: 'medical_services',
    ),
    EmergencyContact(
      id: 'ec_7',
      designation: 'Local Police Station',
      name: 'Dwarka Police Station',
      phone: '112',
      category: 'POLICE',
      iconName: 'local_police',
    ),
  ];

  static const SocietyInfo _mockSocietyInfo = SocietyInfo(
    id: 'soc_001',
    name: 'Green Park Apartments RWA',
    address: 'Sector 12, Dwarka, New Delhi - 110075',
    officeContact: '+91 11 2800 0002',
    officeTiming: '09:00 AM - 06:00 PM (Tue - Sun)',
    emergencyNumbers: ['+91 11 2800 0001', '112'],
    committeeMembers: ['Rajesh Sharma (President)', 'Sunil Gupta (Secretary)', 'Anita Roy (Treasurer)'],
  );

  @override
  Future<ResidentProfile> getResidentProfile() async {
    return getProfile();
  }

  @override
  Future<ResidentProfile> getProfile() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final profile = await remoteDataSource.getResidentProfile();
        await localDataSource.cacheResidentProfile(profile);
        return profile;
      }
      final cached = await localDataSource.getCachedResidentProfile();
      if (cached != null) return cached;
      await localDataSource.cacheResidentProfile(_mockProfile);
      return _mockProfile;
    } catch (_) {
      final cached = await localDataSource.getCachedResidentProfile();
      if (cached != null) return cached;
      return _mockProfile;
    }
  }

  @override
  Future<ResidentProfile> updateProfile(ResidentProfile profile) async {
    try {
      await localDataSource.cacheResidentProfile(profile);
      if (await networkInfo.isConnected && !isDevelopment) {
        final updated = await remoteDataSource.updateResidentProfile(profile);
        await localDataSource.cacheResidentProfile(updated);
        return updated;
      }
      return profile;
    } catch (_) {
      await localDataSource.cacheResidentProfile(profile);
      return profile;
    }
  }

  @override
  Future<HouseDetail> getHouseDetail() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final house = await remoteDataSource.getHouseDetail();
        await localDataSource.cacheHouseDetail(house);
        return house;
      }
      final cached = await localDataSource.getCachedHouseDetail();
      if (cached != null) return cached;
      await localDataSource.cacheHouseDetail(_mockHouse);
      return _mockHouse;
    } catch (_) {
      final cached = await localDataSource.getCachedHouseDetail();
      if (cached != null) return cached;
      return _mockHouse;
    }
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final members = await remoteDataSource.getFamilyMembers();
        await localDataSource.cacheFamilyMembers(members);
        return members;
      }
      final cached = await localDataSource.getCachedFamilyMembers();
      if (cached != null) return cached;
      await localDataSource.cacheFamilyMembers(_mockFamily);
      return _mockFamily;
    } catch (_) {
      final cached = await localDataSource.getCachedFamilyMembers();
      if (cached != null) return cached;
      return _mockFamily;
    }
  }

  @override
  Future<FamilyMember> addFamilyMember(FamilyMember member) async {
    try {
      final currentList = await getFamilyMembers();
      final updatedList = [...currentList, member];
      await localDataSource.cacheFamilyMembers(updatedList);
      if (await networkInfo.isConnected && !isDevelopment) {
        await remoteDataSource.addFamilyMember(member);
      }
      return member;
    } catch (_) {
      return member;
    }
  }

  @override
  Future<List<ResidentVehicle>> getVehicles() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final vehicles = await remoteDataSource.getVehicles();
        await localDataSource.cacheVehicles(vehicles);
        return vehicles;
      }
      final cached = await localDataSource.getCachedVehicles();
      if (cached != null) return cached;
      await localDataSource.cacheVehicles(_mockVehicles);
      return _mockVehicles;
    } catch (_) {
      final cached = await localDataSource.getCachedVehicles();
      if (cached != null) return cached;
      return _mockVehicles;
    }
  }

  @override
  Future<ResidentVehicle> addVehicle(ResidentVehicle vehicle) async {
    try {
      final currentList = await getVehicles();
      final updatedList = [...currentList, vehicle];
      await localDataSource.cacheVehicles(updatedList);
      if (await networkInfo.isConnected && !isDevelopment) {
        await remoteDataSource.addVehicle(vehicle);
      }
      return vehicle;
    } catch (_) {
      return vehicle;
    }
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final contacts = await remoteDataSource.getEmergencyContacts();
        await localDataSource.cacheEmergencyContacts(contacts);
        return contacts;
      }
      final cached = await localDataSource.getCachedEmergencyContacts();
      if (cached != null) return cached;
      await localDataSource.cacheEmergencyContacts(_mockEmergencyContacts);
      return _mockEmergencyContacts;
    } catch (_) {
      final cached = await localDataSource.getCachedEmergencyContacts();
      if (cached != null) return cached;
      return _mockEmergencyContacts;
    }
  }

  @override
  Future<SocietyInfo> getSocietyInfo() async {
    try {
      if (await networkInfo.isConnected && !isDevelopment) {
        final info = await remoteDataSource.getSocietyInfo();
        await localDataSource.cacheSocietyInfo(info);
        return info;
      }
      final cached = await localDataSource.getCachedSocietyInfo();
      if (cached != null) return cached;
      await localDataSource.cacheSocietyInfo(_mockSocietyInfo);
      return _mockSocietyInfo;
    } catch (_) {
      final cached = await localDataSource.getCachedSocietyInfo();
      if (cached != null) return cached;
      return _mockSocietyInfo;
    }
  }
}
