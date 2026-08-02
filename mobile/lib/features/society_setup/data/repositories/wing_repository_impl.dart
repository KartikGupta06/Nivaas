import '../../../../shared/repositories/base_repository.dart';
import '../../domain/entities/wing_config.dart';
import '../../domain/repositories/wing_repository.dart';
import '../datasources/society_setup_remote_datasource.dart';

class WingRepositoryImpl extends BaseRepository implements WingRepository {
  final SocietySetupRemoteDataSource remoteDS;

  WingRepositoryImpl({required this.remoteDS});

  @override
  Future<void> saveWingConfigurations(List<WingConfig> wings) async {
    await remoteDS.createWings('active_society', wings);
  }

  @override
  Future<List<WingConfig>> getWings(String societyId) async {
    return const [];
  }
}
