import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_config_provider.dart';
import '../../../../app/providers/connectivity_provider.dart';
import '../../../../app/providers/dependency_injection_providers.dart';
import '../../data/datasources/resident_remote_datasource.dart';
import '../../data/datasources/resident_local_datasource.dart';
import '../../data/repositories/resident_repository_impl.dart';
import '../../domain/entities/resident_profile.dart';
import '../../domain/entities/house_detail.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/entities/resident_vehicle.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/entities/society_info.dart';

/// Datasource & Repository Providers
final residentRemoteDataSourceProvider = Provider<ResidentRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ResidentRemoteDataSourceImpl(apiClient: apiClient);
});

final residentLocalDataSourceProvider = Provider<ResidentLocalDataSource>((ref) {
  return ResidentLocalDataSourceImpl();
});

final residentRepositoryProvider = Provider<ResidentRepositoryImpl>((ref) {
  final remoteDS = ref.watch(residentRemoteDataSourceProvider);
  final localDS = ref.watch(residentLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final appConfig = ref.watch(appConfigProvider);

  return ResidentRepositoryImpl(
    remoteDataSource: remoteDS,
    localDataSource: localDS,
    networkInfo: networkInfo,
    isDevelopment: appConfig.isDevelopment,
  );
});

/// State Notifier for Resident Profile
class ProfileNotifier extends StateNotifier<AsyncValue<ResidentProfile>> {
  final ResidentRepositoryImpl _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile();
      state = AsyncValue.data(profile);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<bool> updateProfile(ResidentProfile updated) async {
    try {
      final profile = await _repository.updateProfile(updated);
      state = AsyncValue.data(profile);
      return true;
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
      return false;
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ResidentProfile>>((ref) {
  final repo = ref.watch(residentRepositoryProvider);
  return ProfileNotifier(repo);
});

/// State Notifier for House Detail
class HouseNotifier extends StateNotifier<AsyncValue<HouseDetail>> {
  final ResidentRepositoryImpl _repository;

  HouseNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHouseDetail();
  }

  Future<void> loadHouseDetail() async {
    state = const AsyncValue.loading();
    try {
      final house = await _repository.getHouseDetail();
      state = AsyncValue.data(house);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}

final houseNotifierProvider =
    StateNotifierProvider<HouseNotifier, AsyncValue<HouseDetail>>((ref) {
  final repo = ref.watch(residentRepositoryProvider);
  return HouseNotifier(repo);
});

/// State Notifier for Family Members
class FamilyNotifier extends StateNotifier<AsyncValue<List<FamilyMember>>> {
  final ResidentRepositoryImpl _repository;

  FamilyNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    state = const AsyncValue.loading();
    try {
      final members = await _repository.getFamilyMembers();
      state = AsyncValue.data(members);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<bool> addFamilyMember(FamilyMember member) async {
    try {
      final added = await _repository.addFamilyMember(member);
      state.whenData((current) {
        state = AsyncValue.data([...current, added]);
      });
      return true;
    } catch (err) {
      return false;
    }
  }
}

final familyNotifierProvider =
    StateNotifierProvider<FamilyNotifier, AsyncValue<List<FamilyMember>>>((ref) {
  final repo = ref.watch(residentRepositoryProvider);
  return FamilyNotifier(repo);
});

/// State Notifier for Vehicles
class VehicleNotifier extends StateNotifier<AsyncValue<List<ResidentVehicle>>> {
  final ResidentRepositoryImpl _repository;

  VehicleNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    state = const AsyncValue.loading();
    try {
      final vehicles = await _repository.getVehicles();
      state = AsyncValue.data(vehicles);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<bool> addVehicle(ResidentVehicle vehicle) async {
    try {
      final added = await _repository.addVehicle(vehicle);
      state.whenData((current) {
        state = AsyncValue.data([...current, added]);
      });
      return true;
    } catch (err) {
      return false;
    }
  }
}

final vehicleNotifierProvider =
    StateNotifierProvider<VehicleNotifier, AsyncValue<List<ResidentVehicle>>>((ref) {
  final repo = ref.watch(residentRepositoryProvider);
  return VehicleNotifier(repo);
});

/// Emergency Contacts Provider
final emergencyContactsProvider = FutureProvider<List<EmergencyContact>>((ref) async {
  final repo = ref.watch(residentRepositoryProvider);
  return await repo.getEmergencyContacts();
});

/// Society Info Provider
final societyInfoProvider = FutureProvider<SocietyInfo>((ref) async {
  final repo = ref.watch(residentRepositoryProvider);
  return await repo.getSocietyInfo();
});
