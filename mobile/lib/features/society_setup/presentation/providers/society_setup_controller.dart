import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_config_provider.dart';
import '../../../../app/providers/connectivity_provider.dart';
import '../../../../app/providers/dependency_injection_providers.dart';
import '../../data/datasources/society_setup_local_datasource.dart';
import '../../data/datasources/society_setup_remote_datasource.dart';
import '../../data/repositories/society_setup_repository_impl.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/maintenance_config.dart';
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
    loadDraft();
  }

  void setStep(int step) {
    if (step >= 0 && step <= 7) {
      state = state.copyWith(currentStep: step, errorMessage: null);
    }
  }

  void updateProfile(SocietyProfile profile) {
    state = state.copyWith(profile: profile);
    _autoSaveDraft();
  }

  void addWing(String name) {
    if (name.trim().isEmpty) return;
    
    // Check duplicate wing name
    if (state.wings.any((w) => w.name.toLowerCase() == name.trim().toLowerCase())) {
      state = state.copyWith(errorMessage: 'Wing name "$name" already exists.');
      return;
    }

    final newWing = WingConfig(
      id: 'wing_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      totalFloors: 4,
      flatsPerFloor: 4,
      displayOrder: state.wings.length,
    );
    state = state.copyWith(wings: [...state.wings, newWing], errorMessage: null);
    generateHouseLayouts();
    _autoSaveDraft();
  }

  void removeWing(String id) {
    final updated = state.wings.where((w) => w.id != id).toList();
    state = state.copyWith(wings: updated);
    generateHouseLayouts();
    _autoSaveDraft();
  }

  void renameWing(String id, String newName) {
    final name = newName.trim();
    if (name.isEmpty) return;
    final updated = state.wings.map((w) {
      if (w.id == id) return w.copyWith(name: name);
      return w;
    }).toList();
    state = state.copyWith(wings: updated);
    generateHouseLayouts();
    _autoSaveDraft();
  }

  void reorderWings(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final updated = List<WingConfig>.from(state.wings);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    final reordered = updated.asMap().entries.map((e) => e.value.copyWith(displayOrder: e.key)).toList();
    state = state.copyWith(wings: reordered);
    generateHouseLayouts();
    _autoSaveDraft();
  }

  void updateWingConfig(String id, int floors, int flatsPerFloor, {int basementFloors = 0, bool hasTerrace = false}) {
    if (floors <= 0 || floors > 100) {
      state = state.copyWith(errorMessage: 'Invalid floor count. Must be between 1 and 100.');
      return;
    }
    final updated = state.wings.map((w) {
      if (w.id == id) {
        return w.copyWith(
          totalFloors: floors,
          flatsPerFloor: flatsPerFloor,
          basementFloors: basementFloors,
          hasTerrace: hasTerrace,
        );
      }
      return w;
    }).toList();
    state = state.copyWith(wings: updated, errorMessage: null);
    generateHouseLayouts();
    _autoSaveDraft();
  }

  /// House Layout Engine: Automatically generates floor layouts for every wing
  void generateHouseLayouts() {
    final List<HouseUnit> houses = [];

    for (final wing in state.wings) {
      final cleanWingName = wing.name.replaceAll(RegExp(r'^(Wing|Block|Tower)\s*'), '');

      for (int floor = 1; floor <= wing.totalFloors; floor++) {
        for (int flatIndex = 1; flatIndex <= wing.flatsPerFloor; flatIndex++) {
          final flatNum = wing.numberingStrategy == FloorNumberingStrategy.sequential
              ? '${(floor - 1) * wing.flatsPerFloor + flatIndex}'
              : '$cleanWingName-${floor * 100 + flatIndex}';

          final existingMatch = state.generatedHouses.cast<HouseUnit?>().firstWhere(
                (h) => h?.flatNumber == flatNum && h?.wingName == wing.name,
                orElse: () => null,
              );

          if (existingMatch != null) {
            houses.add(existingMatch);
          } else {
            houses.add(HouseUnit(
              id: 'house_${wing.name}_${floor}_$flatIndex',
              wingName: wing.name,
              floorNumber: floor,
              flatNumber: flatNum,
              type: flatIndex % 2 == 0 ? HouseType.bhk3 : HouseType.bhk2,
              areaSqFt: flatIndex % 2 == 0 ? 1450.0 : 1100.0,
              maintenanceCategory: flatIndex % 2 == 0 ? 'PREMIUM' : 'STANDARD',
            ));
          }
        }
      }
    }

    state = state.copyWith(generatedHouses: houses);
  }

  void updateHouseType(String houseId, HouseType type) {
    final updated = state.generatedHouses.map((h) {
      if (h.id == houseId) return h.copyWith(type: type, isCustomized: true);
      return h;
    }).toList();
    state = state.copyWith(generatedHouses: updated);
    _autoSaveDraft();
  }

  void updateHouseDetails(String houseId, {HouseType? type, double? areaSqFt, String? category, String? parkingSlot}) {
    final updated = state.generatedHouses.map((h) {
      if (h.id == houseId) {
        return h.copyWith(
          type: type ?? h.type,
          areaSqFt: areaSqFt ?? h.areaSqFt,
          maintenanceCategory: category ?? h.maintenanceCategory,
          parkingSlot: parkingSlot ?? h.parkingSlot,
          isCustomized: true,
        );
      }
      return h;
    }).toList();
    state = state.copyWith(generatedHouses: updated);
    _autoSaveDraft();
  }

  void assignOwner(String houseId, String ownerName, String ownerPhone, {String? email, String? emergencyContact}) {
    if (ownerPhone.isNotEmpty) {
      final phoneRegExp = RegExp(r'^[6-9]\d{9}$');
      if (!phoneRegExp.hasMatch(ownerPhone.trim())) {
        state = state.copyWith(errorMessage: 'Invalid phone number format.');
        return;
      }
    }

    final updated = state.generatedHouses.map((h) {
      if (h.id == houseId) {
        return h.copyWith(
          ownerName: ownerName.trim(),
          ownerPhone: ownerPhone.trim(),
          ownerEmail: email?.trim(),
          emergencyContact: emergencyContact?.trim(),
        );
      }
      return h;
    }).toList();
    state = state.copyWith(generatedHouses: updated, errorMessage: null);
    _autoSaveDraft();
  }

  void updateMaintenanceConfig(MaintenanceConfig config) {
    state = state.copyWith(maintenanceConfig: config);
    _autoSaveDraft();
  }

  Future<void> saveDraft() async {
    await _repository.saveDraftSetup(
      profile: state.profile,
      wings: state.wings,
      houses: state.generatedHouses,
      maintenance: state.maintenanceConfig,
    );
    state = state.copyWith(isDraftSaved: true);
  }

  Future<void> loadDraft() async {
    try {
      final draft = await _repository.loadDraftSetup();
      if (draft != null) {
        if (draft['profile'] != null) {
          final profile = SocietyProfile.fromJson(draft['profile'] as Map<String, dynamic>);
          state = state.copyWith(profile: profile);
        }
        if (draft['wings'] != null) {
          final wings = (draft['wings'] as List<dynamic>)
              .map((w) => WingConfig.fromJson(w as Map<String, dynamic>))
              .toList();
          state = state.copyWith(wings: wings);
        }
        if (draft['houses'] != null) {
          final houses = (draft['houses'] as List<dynamic>)
              .map((h) => HouseUnit.fromJson(h as Map<String, dynamic>))
              .toList();
          state = state.copyWith(generatedHouses: houses);
        }
        if (draft['maintenance'] != null) {
          final maintenance = MaintenanceConfig.fromJson(draft['maintenance'] as Map<String, dynamic>);
          state = state.copyWith(maintenanceConfig: maintenance);
        }
      }
    } catch (_) {}
  }

  Future<void> clearDraft() async {
    await _repository.clearDraftSetup();
    state = SocietySetupState.initial();
    generateHouseLayouts();
  }

  void _autoSaveDraft() {
    saveDraft();
  }

  Future<bool> submitFinalSetup() async {
    if (state.profile.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Society name cannot be empty.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final success = await _repository.submitFinalSocietySetup(
        profile: state.profile,
        wings: state.wings,
        houses: state.generatedHouses,
        defaultMaintenanceAmount: state.maintenanceConfig.defaultAmount,
        maintenanceDueDate: state.maintenanceConfig.dueDateDay,
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
      WingConfig(id: 'wing_a', name: 'Wing A', totalFloors: 4, flatsPerFloor: 4, displayOrder: 0),
      WingConfig(id: 'wing_b', name: 'Wing B', totalFloors: 4, flatsPerFloor: 4, displayOrder: 1),
    ];

    state = state.copyWith(
      profile: demoProfile,
      wings: demoWings,
      maintenanceConfig: const MaintenanceConfig(
        defaultAmount: 3200.0,
        dueDateDay: 5,
      ),
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
