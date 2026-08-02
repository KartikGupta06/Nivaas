import '../entities/society_profile.dart';

abstract class SocietyRepository {
  Future<void> saveSocietyProfile(SocietyProfile profile);
  Future<SocietyProfile?> getSocietyProfile(String id);
}
