import 'package:flutter_test/flutter_test.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_unit.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/society_profile.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/wing_config.dart';
import 'package:nivaas_mobile/features/society_setup/domain/repositories/society_setup_repository.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_state.dart';

class MockSocietySetupRepository implements SocietySetupRepository {
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
  }) async {}

  @override
  Future<Map<String, dynamic>?> loadDraftSetup() async => null;

  @override
  Future<void> clearDraftSetup() async {}

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

  group('House Layout Engine Unit Tests', () {
    test('Initial House Layout Engine auto-generates 32 flats across 2 wings', () {
      expect(controller.currentState.wings.length, equals(2));
      expect(controller.currentState.generatedHouses.length, equals(32));
    });

    test('Adding new wing triggers Layout Engine recalculation', () {
      controller.addWing('Wing C');
      expect(controller.currentState.wings.length, equals(3));
      expect(controller.currentState.generatedHouses.length, equals(48));
    });

    test('Dev Demo Generator populates Green Park Apartments RWA demo profile', () {
      controller.generateDemoSociety();

      expect(controller.currentState.profile.name, equals('Green Park Apartments RWA'));
      expect(controller.currentState.profile.city, equals('New Delhi'));
      expect(controller.currentState.generatedHouses.isNotEmpty, isTrue);
      expect(controller.currentState.generatedHouses.any((h) => h.ownerName != null), isTrue);
    });
  });
}

extension on SocietySetupController {
  SocietySetupState get currentState => state;
}
