import '../entities/house_unit.dart';

abstract class HouseRepository {
  Future<void> saveGeneratedHouses(List<HouseUnit> houses);
  Future<List<HouseUnit>> getHouses(String societyId);
}
