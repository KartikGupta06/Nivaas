import '../entities/wing_config.dart';

abstract class WingRepository {
  Future<void> saveWingConfigurations(List<WingConfig> wings);
  Future<List<WingConfig>> getWings(String societyId);
}
