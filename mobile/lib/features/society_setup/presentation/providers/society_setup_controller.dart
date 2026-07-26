import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_config_provider.dart';
import '../../../../app/providers/connectivity_provider.dart';
import '../../../../app/providers/dependency_injection_providers.dart';
import '../../data/datasources/society_setup_local_datasource.dart';
import '../../data/datasources/society_setup_remote_datasource.dart';
import '../../data/repositories/society_setup_repository_impl.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/society_profile.dart';
import '../../domain/entities/wing_config.dart';
import '../../domain/repositories/society_setup_repository.dart';
import 'society_setup_state.dart';

final societySetupRemoteDSProvider = Provider<SocietySetupRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SocietySetupRemoteDataSourceImpl(apiClient);
});

final societySetupLocalDSProvider = Provider<SocietySetupLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SocietySetupLocalDataSourceImpl(secureStorage);
});

final societySetupRepositoryProvider = Provider<SocietySetupRepository>((ref) {
  final remoteDS = ref.watch(societySetupRemoteDSProvider);
  final localDS = ref.watch(societySetupLocalDSProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final appConfig = ref.watch(appConfigProvider);

  return SocietySetupRepositoryImpl(
    remoteDS: remoteDS,
    localDS: localDS,
    networkInfo: networkInfo,
    isDevelopment: appConfig.isDevelopment,
  );
});

final societySetupControllerProvider = StateNotifierProvider<SocietySetupController, SocietySetupState>((ref) {
  final repository = ref.watch(societySetupRepositoryProvider);
  return SocietySetupController(repository);
});

class SocietySetupController extends StateNotifier<SocietySetupState> {
  final SocietySetupRepository _repository;

  SocietySetupController(this._repository) : super(SocietySetupState.initial()) {
    generateHouseLayouts();
  }

  void setStep(int step) {
    if (step >= 0 && step <= 5) {
      state = state.copyWith(currentStep: step, errorMessage: null);
    }
  }

  void updateProfile(SocietyProfile profile) {
    state = state.copyWith(profile: profile);
  }

  void addWing(String name) {
    final newWing = WingConfig(
      id: 'wing_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      totalFloors: 4,
      flatsPerFloor: 4,
    );
    state = state.copyWith(wings: [...state.wings, newWing]);
    generateHouseLayouts();
  }

  void removeWing(String id) {
    final updated = state.wings.where((w) => w.id != id).toList();
    state = state.copyWith(wings: updated);
    generateHouseLayouts();
  }

  void updateWingConfig(String id, int floors, int flatsPerFloor) {
    final updated = state.wings.map((w) {
      if (w.id == id) {
        return w.copyWith(totalFloors: floors, flatsPerFloor: flatsPerFloor);
      }
      return w;
    }).toList();
    state = state.copyWith(wings: updated);
    generateHouseLayouts();
  }

  /// House Layout Engine: Automatically generates floor layouts for every wing
  void generateHouseLayouts() {
    final List<HouseUnit> houses = [];

    for (final wing in state.wings) {
      for (int floor = 1; floor <= wing.totalFloors; floor++) {
        for (int flatIndex = 1; flatIndex <= wing.flatsPerFloor; flatIndex++) {
          final flatNum = '${wing.name.replaceAll('Wing ', '')}-${floor * 100 + flatIndex}';
          houses.add(HouseUnit(
            id: 'house_${wing.name}_${floor}_$flatIndex',
            wingName: wing.name,
            floorNumber: floor,
            flatNumber: flatNum,
            type: flatIndex % 2 == 0 ? HouseType.bhk3 : HouseType.bhk2,
            areaSqFt: flatIndex % 2 == 0 ? 1450.0 : 1100.0,
          ));
        }
      }
    }

    state = state.copyWith(generatedHouses: houses);
  }

  void updateHouseType(String houseId, HouseType type) {
    final updated = state.generatedHouses.map((h) {
      if (h.id == houseId) return h.copyWith(type: type);
      return h;
    }).toList();
    state = state.copyWith(generatedHouses: updated);
  }

  void assignOwner(String houseId, String ownerName, String ownerPhone) {
    final updated = state.generatedHouses.map((h) {
      if (h.id == houseId) {
        return h.copyWith(ownerName: ownerName, ownerPhone: ownerPhone);
      }
      return h;
    }).toList();
    state = state.copyWith(generatedHouses: updated);
  }

  void updateMaintenanceConfig(double amount, int dueDate) {
    state = state.copyWith(
      defaultMaintenanceAmount: amount,
      maintenanceDueDate: dueDate,
    );
  }

  Future<bool> submitFinalSetup() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final success = await _repository.submitFinalSocietySetup(
        profile: state.profile,
        wings: state.wings,
        houses: state.generatedHouses,
        defaultMaintenanceAmount: state.defaultMaintenanceAmount,
        maintenanceDueDate: state.maintenanceDueDate,
      );
      state = state.copyWith(isSubmitting: false, isCompleted: success);
      return success;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Development Mode Demo Generator: Instantly populates a full realistic society
  void generateDemoSociety() {
    const demoProfile = SocietyProfile(
      id: 'soc_demo_999',
      name: 'Green Park Apartments RWA',
      type: SocietyType.housingSociety,
      address: 'Plot 42, Sector 18, Dwarka',
      city: 'New Delhi',
      state: 'Delhi',
      pinCode: '110075',
      contactNumber: '9876543210',
      email: 'admin@greenparkrwa.in',
      registrationNumber: 'RWA/DEL/2024/9812',
    );

    const demoWings = [
      WingConfig(id: 'wing_a', name: 'Wing A', totalFloors: 4, flatsPerFloor: 4),
      WingConfig(id: 'wing_b', name: 'Wing B', totalFloors: 4, flatsPerFloor: 4),
    ];

    state = state.copyWith(
      profile: demoProfile,
      wings: demoWings,
      defaultMaintenanceAmount: 3200.0,
      maintenanceDueDate: 5,
    );

    generateHouseLayouts();

    // Assign sample initial owners for demo
    if (state.generatedHouses.isNotEmpty) {
      final sampleOwners = [
        ('A-101', 'Rajesh Sharma', '9876543211'),
        ('A-102', 'Priya Nair', '9876543210'),
        ('A-201', 'Vikram Patel', '9811223344'),
        ('B-101', 'Ananya Roy', '9988776655'),
      ];

      final updatedHouses = state.generatedHouses.map((h) {
        final match = sampleOwners.cast<(String, String, String)?>().firstWhere(
              (s) => s?.$1 == h.flatNumber,
              orElse: () => null,
            );
        if (match != null) {
          return h.copyWith(ownerName: match.$2, ownerPhone: match.$3);
        }
        return h;
      }).toList();

      state = state.copyWith(generatedHouses: updatedHouses);
    }
  }
}
