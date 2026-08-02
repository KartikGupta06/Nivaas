import '../entities/house_owner.dart';

abstract class OwnerRepository {
  Future<void> assignOwner(HouseOwner owner);
  Future<List<HouseOwner>> getOwners(String societyId);
}
