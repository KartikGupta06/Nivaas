import '../../../../shared/repositories/base_repository.dart';
import '../../domain/entities/house_owner.dart';
import '../../domain/repositories/owner_repository.dart';
import '../datasources/society_setup_remote_datasource.dart';

class OwnerRepositoryImpl extends BaseRepository implements OwnerRepository {
  final SocietySetupRemoteDataSource remoteDS;

  OwnerRepositoryImpl({required this.remoteDS});

  @override
  Future<void> assignOwner(HouseOwner owner) async {
    await remoteDS.assignOwners('active_society', [owner]);
  }

  @override
  Future<List<HouseOwner>> getOwners(String societyId) async {
    return const [];
  }
}
