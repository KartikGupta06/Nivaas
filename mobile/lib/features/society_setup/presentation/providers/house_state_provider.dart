import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/wing_config.dart';

final houseListProvider = StateNotifierProvider<HouseListNotifier, List<HouseUnit>>((ref) {
  return HouseListNotifier();
});

class HouseListNotifier extends StateNotifier<List<HouseUnit>> {
  HouseListNotifier() : super(const []);

  /// House Layout Engine: Configures ONLY ONE floor layout per wing, auto-generates all upper floors.
  void generateLayouts(List<WingConfig> wings) {
    final List<HouseUnit> houses = [];

    for (final wing in wings) {
      final cleanWingName = wing.name.replaceAll(RegExp(r'^(Wing|Block|Tower)\s*'), '');

      for (int floor = 1; floor <= wing.totalFloors; floor++) {
        for (int flatIndex = 1; flatIndex <= wing.flatsPerFloor; flatIndex++) {
          final flatNum = wing.numberingStrategy == FloorNumberingStrategy.sequential
              ? '${(floor - 1) * wing.flatsPerFloor + flatIndex}'
              : '$cleanWingName-${floor * 100 + flatIndex}';

          final isEven = flatIndex % 2 == 0;
          houses.add(HouseUnit(
            id: 'house_${wing.name}_${floor}_$flatIndex',
            wingName: wing.name,
            floorNumber: floor,
            flatNumber: flatNum,
            type: isEven ? HouseType.bhk3 : HouseType.bhk2,
            areaSqFt: isEven ? 1450.0 : 1100.0,
            maintenanceCategory: isEven ? 'PREMIUM' : 'STANDARD',
          ));
        }
      }
    }

    state = houses;
  }

  void updateHouseType(String houseId, HouseType type) {
    state = state.map((h) {
      if (h.id == houseId) return h.copyWith(type: type, isCustomized: true);
      return h;
    }).toList();
  }

  void updateHouseDetails(String houseId, {HouseType? type, double? areaSqFt, String? category, String? parkingSlot}) {
    state = state.map((h) {
      if (h.id == houseId) {
        return h.copyWith(
          type: type ?? h.type,
          areaSqFt: areaSqFt ?? h.areaSqFt,
          maintenanceCategory: category ?? h.maintenanceCategory,
          parkingSlot: parkingSlot ?? h.parkingSlot,
          isCustomized: true,
        );
      }
      return h;
    }).toList();
  }

  void assignOwner(String houseId, String ownerName, String ownerPhone, {String? email, String? emergencyContact}) {
    state = state.map((h) {
      if (h.id == houseId) {
        return h.copyWith(
          ownerName: ownerName,
          ownerPhone: ownerPhone,
          ownerEmail: email,
          emergencyContact: emergencyContact,
        );
      }
      return h;
    }).toList();
  }

  void setHouses(List<HouseUnit> houses) {
    state = houses;
  }
}
