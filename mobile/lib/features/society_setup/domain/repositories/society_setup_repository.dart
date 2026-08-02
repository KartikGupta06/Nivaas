import '../entities/house_unit.dart';
import '../entities/society_profile.dart';
import '../entities/wing_config.dart';
import '../entities/maintenance_config.dart';

abstract class SocietySetupRepository {
  Future<void> saveSocietyProfile(SocietyProfile profile);
  Future<void> saveWingConfigurations(List<WingConfig> wings);
  Future<void> saveGeneratedHouses(List<HouseUnit> houses);

  Future<void> saveDraftSetup({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required MaintenanceConfig maintenance,
  });

  Future<Map<String, dynamic>?> loadDraftSetup();
  Future<void> clearDraftSetup();

  Future<bool> submitFinalSocietySetup({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required double defaultMaintenanceAmount,
    required int maintenanceDueDate,
  });
}
