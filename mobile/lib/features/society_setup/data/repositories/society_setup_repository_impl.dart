import '../../../../core/network/network_info.dart';
import '../../../../shared/repositories/base_repository.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/maintenance_config.dart';
import '../../domain/entities/society_profile.dart';
import '../../domain/entities/wing_config.dart';
import '../../domain/repositories/society_setup_repository.dart';
import '../datasources/society_setup_local_datasource.dart';
import '../datasources/society_setup_remote_datasource.dart';

class SocietySetupRepositoryImpl extends BaseRepository implements SocietySetupRepository {
  final SocietySetupRemoteDataSource _remoteDS;
  final SocietySetupLocalDataSource _localDS;
  final NetworkInfo _networkInfo;
  final bool isDevelopment;

  SocietySetupRepositoryImpl({
    required SocietySetupRemoteDataSource remoteDS,
    required SocietySetupLocalDataSource localDS,
    required NetworkInfo networkInfo,
    this.isDevelopment = true,
  })  : _remoteDS = remoteDS,
        _localDS = localDS,
        _networkInfo = networkInfo;

  @override
  Future<void> saveSocietyProfile(SocietyProfile profile) async {
    if (isDevelopment) return;
    await _remoteDS.createSociety(profile);
  }

  @override
  Future<void> saveWingConfigurations(List<WingConfig> wings) async {
    if (isDevelopment) return;
    await _remoteDS.createWings('temp_id', wings);
  }

  @override
  Future<void> saveGeneratedHouses(List<HouseUnit> houses) async {
    if (isDevelopment) return;
    await _remoteDS.createHouses('temp_id', houses);
  }

  @override
  Future<void> saveDraftSetup({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required MaintenanceConfig maintenance,
  }) async {
    final draft = {
      'profile': profile.toJson(),
      'wings': wings.map((w) => w.toJson()).toList(),
      'houses': houses.map((h) => h.toJson()).toList(),
      'maintenance': maintenance.toJson(),
      'saved_at': DateTime.now().toIso8601String(),
    };
    await _localDS.saveDraft(draft);
  }

  @override
  Future<Map<String, dynamic>?> loadDraftSetup() async {
    return await _localDS.getDraft();
  }

  @override
  Future<void> clearDraftSetup() async {
    await _localDS.clearDraft();
  }

  @override
  Future<bool> submitFinalSocietySetup({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required double defaultMaintenanceAmount,
    required int maintenanceDueDate,
  }) async {
    if (isDevelopment) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      await _localDS.clearDraft();
      return true;
    }

    if (!await _networkInfo.isConnected) {
      // Save draft for future offline sync
      await saveDraftSetup(
        profile: profile,
        wings: wings,
        houses: houses,
        maintenance: MaintenanceConfig(
          defaultAmount: defaultMaintenanceAmount,
          dueDateDay: maintenanceDueDate,
        ),
      );
      return true;
    }

    await _remoteDS.submitFullOnboarding(
      profile: profile,
      wings: wings,
      houses: houses,
      maintenanceAmount: defaultMaintenanceAmount,
      dueDate: maintenanceDueDate,
    );
    await _localDS.clearDraft();
    return true;
  }
}
