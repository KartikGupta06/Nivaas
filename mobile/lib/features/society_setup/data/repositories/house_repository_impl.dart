import '../../../../shared/repositories/base_repository.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/repositories/house_repository.dart';
import '../datasources/society_setup_remote_datasource.dart';

class HouseRepositoryImpl extends BaseRepository implements HouseRepository {
  final SocietySetupRemoteDataSource remoteDS;

  HouseRepositoryImpl({required this.remoteDS});

  @override
  Future<void> saveGeneratedHouses(List<HouseUnit> houses) async {
    await remoteDS.createHouses('active_society', houses);
  }

  @override
  Future<List<HouseUnit>> getHouses(String societyId) async {
    return const [];
  }
}
