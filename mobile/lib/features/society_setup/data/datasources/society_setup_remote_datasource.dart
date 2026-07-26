import '../../../../core/network/api_client.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/society_profile.dart';
import '../../domain/entities/wing_config.dart';

abstract class SocietySetupRemoteDataSource {
  Future<void> createSociety(SocietyProfile profile);
  Future<void> createWings(String societyId, List<WingConfig> wings);
  Future<void> createHouses(String societyId, List<HouseUnit> houses);
  Future<void> submitFullOnboarding({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required double maintenanceAmount,
    required int dueDate,
  });
}

class SocietySetupRemoteDataSourceImpl implements SocietySetupRemoteDataSource {
  final ApiClient _apiClient;

  SocietySetupRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> createSociety(SocietyProfile profile) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/societies/setup',
      data: profile.toJson(),
    );
  }

  @override
  Future<void> createWings(String societyId, List<WingConfig> wings) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/societies/$societyId/wings',
      data: {'wings': wings.map((w) => w.toJson()).toList()},
    );
  }

  @override
  Future<void> createHouses(String societyId, List<HouseUnit> houses) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/societies/$societyId/houses',
      data: {'houses': houses.map((h) => h.toJson()).toList()},
    );
  }

  @override
  Future<void> submitFullOnboarding({
    required SocietyProfile profile,
    required List<WingConfig> wings,
    required List<HouseUnit> houses,
    required double maintenanceAmount,
    required int dueDate,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/societies/onboarding/complete',
      data: {
        'profile': profile.toJson(),
        'wings': wings.map((w) => w.toJson()).toList(),
        'houses': houses.map((h) => h.toJson()).toList(),
        'maintenance_amount': maintenanceAmount,
        'maintenance_due_date': dueDate,
      },
    );
  }
}
