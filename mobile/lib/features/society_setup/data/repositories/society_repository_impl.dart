import '../../../../shared/repositories/base_repository.dart';
import '../../domain/entities/society_profile.dart';
import '../../domain/repositories/society_repository.dart';
import '../datasources/society_setup_remote_datasource.dart';

class SocietyRepositoryImpl extends BaseRepository implements SocietyRepository {
  final SocietySetupRemoteDataSource remoteDS;

  SocietyRepositoryImpl({required this.remoteDS});

  @override
  Future<void> saveSocietyProfile(SocietyProfile profile) async {
    await remoteDS.createSociety(profile);
  }

  @override
  Future<SocietyProfile?> getSocietyProfile(String id) async {
    return null;
  }
}
