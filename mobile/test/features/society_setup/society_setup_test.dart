import 'package:flutter_test/flutter_test.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_unit.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/maintenance_config.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/society_profile.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/wing_config.dart';
import 'package:nivaas_mobile/features/society_setup/domain/repositories/society_setup_repository.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_state.dart';

class MockSocietySetupRepository implements SocietySetupRepository {
  Map<String, dynamic>? _draftStore;

  @override
  Future<void> saveSocietyProfile(SocietyProfile profile) async {}

  @override
  Future<void> saveWingConfigurations(List<WingConfig> wings) async {}

  @override
  Future<void> saveGeneratedHouses(List<HouseUnit> houses) async {}

  @override
  Future<void> saveDraftSetup({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required MaintenanceConfig maintenance,
  }) async {
    _draftStore = {
      'profile': profile.toJson(),
      'wings': wings.map((w) => w.toJson()).toList(),
      'houses': houses.map((h) => h.toJson()).toList(),
      'maintenance': maintenance.toJson(),
    };
  }

  @override
  Future<Map<String, dynamic>?> loadDraftSetup() async => _draftStore;

  @override
  Future<void> clearDraftSetup() async {
    _draftStore = null;
  }

  @override
  Future<bool> submitFinalSocietySetup({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required double defaultMaintenanceAmount,
    required int maintenanceDueDate,
  }) async {
    return true;
  }
}

void main() {
  late SocietySetupController controller;
  late MockSocietySetupRepository repository;

  setUp(() {
    repository = MockSocietySetupRepository();
    controller = SocietySetupController(repository);
  });

  group('Phase 03 Society Setup Engine Unit Tests', () {
    test('Initial House Layout Engine auto-generates 32 flats across 2 wings', () {
      expect(controller.currentState.wings.length, equals(2));
      expect(controller.currentState.generatedHouses.length, equals(32));
    });

    test('Adding new wing triggers Layout Engine recalculation', () {
      controller.addWing('Wing C');
      expect(controller.currentState.wings.length, equals(3));
      expect(controller.currentState.generatedHouses.length, equals(48));
    });

    test('Duplicate Wing name addition shows error state', () {
      controller.addWing('Wing A');
      expect(controller.currentState.errorMessage, contains('already exists'));
    });

    test('Renaming Wing updates generated flat labels', () {
      controller.renameWing('wing_a', 'Tower Alpha');
      expect(controller.currentState.wings.firstWhere((w) => w.id == 'wing_a').name, equals('Tower Alpha'));
      expect(controller.currentState.generatedHouses.any((h) => h.wingName == 'Tower Alpha'), isTrue);
    });

    test('Reordering Wings updates displayOrder correctly', () {
      controller.reorderWings(0, 2);
      expect(controller.currentState.wings[0].name, equals('Wing B'));
      expect(controller.currentState.wings[1].name, equals('Wing A'));
    });

    test('Customizing House details marks flat as customized', () {
      final firstHouse = controller.currentState.generatedHouses.first;
      controller.updateHouseType(firstHouse.id, HouseType.penthouse);

      final updated = controller.currentState.generatedHouses.firstWhere((h) => h.id == firstHouse.id);
      expect(updated.type, equals(HouseType.penthouse));
      expect(updated.isCustomized, isTrue);
    });

    test('Assigning Owner validates Indian mobile phone format', () {
      final firstHouse = controller.currentState.generatedHouses.first;
      controller.assignOwner(firstHouse.id, 'Ramesh Sharma', '12345'); // Invalid phone

      expect(controller.currentState.errorMessage, contains('Invalid phone number format'));

      controller.assignOwner(firstHouse.id, 'Ramesh Sharma', '9876543210'); // Valid phone
      expect(controller.currentState.errorMessage, isNull);
      final updated = controller.currentState.generatedHouses.firstWhere((h) => h.id == firstHouse.id);
      expect(updated.ownerName, equals('Ramesh Sharma'));
    });

    test('Dev Demo Generator populates Green Park Apartments RWA demo profile', () {
      controller.generateDemoSociety();

      expect(controller.currentState.profile.name, equals('Green Park Apartments RWA'));
      expect(controller.currentState.profile.city, equals('New Delhi'));
      expect(controller.currentState.generatedHouses.isNotEmpty, isTrue);
      expect(controller.currentState.generatedHouses.any((h) => h.ownerName != null), isTrue);
    });

    test('Draft Progress Saving and Restoring lifecycle works', () async {
      const testProfile = SocietyProfile(
        id: 'soc_test_123',
        name: 'Royal Heritage Society',
        type: SocietyType.residentialComplex,
        address: '12 MG Road',
        city: 'Bengaluru',
        state: 'Karnataka',
        pinCode: '560001',
        contactNumber: '9876543210',
      );

      controller.updateProfile(testProfile);
      await controller.saveDraft();

      final reloadedController = SocietySetupController(repository);
      await reloadedController.loadDraft();

      expect(reloadedController.currentState.profile.name, equals('Royal Heritage Society'));
    });

    test('Final Submission triggers repository setup completion', () async {
      controller.generateDemoSociety();
      final result = await controller.submitFinalSetup();

      expect(result, isTrue);
      expect(controller.currentState.isCompleted, isTrue);
    });
  });
}

extension on SocietySetupController {
  SocietySetupState get currentState => state;
}
