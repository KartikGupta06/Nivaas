import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/floor_config.dart';

final floorListProvider = StateNotifierProvider<FloorListNotifier, List<FloorConfig>>((ref) {
  return FloorListNotifier();
});

class FloorListNotifier extends StateNotifier<List<FloorConfig>> {
  FloorListNotifier() : super(const []);

  void generateFloorsForWing(String wingId, int totalFloors, {int basementCount = 0, bool hasTerrace = false}) {
    final List<FloorConfig> floors = [];

    // Basements
    for (int b = basementCount; b >= 1; b--) {
      floors.add(FloorConfig(
        id: 'floor_${wingId}_b$b',
        wingId: wingId,
        floorNumber: -b,
        customName: 'Basement B$b',
        isBasement: true,
      ));
    }

    // Ground & Upper Floors
    for (int f = 0; f <= totalFloors; f++) {
      floors.add(FloorConfig(
        id: 'floor_${wingId}_$f',
        wingId: wingId,
        floorNumber: f,
        customName: f == 0 ? 'Ground Floor' : 'Floor $f',
      ));
    }

    // Terrace
    if (hasTerrace) {
      floors.add(FloorConfig(
        id: 'floor_${wingId}_terrace',
        wingId: wingId,
        floorNumber: totalFloors + 1,
        customName: 'Terrace Floor',
        isTerrace: true,
      ));
    }

    state = [...state.where((fl) => fl.wingId != wingId), ...floors];
  }

  void setCustomFloorName(String id, String customName) {
    state = state.map((fl) {
      if (fl.id == id) return fl.copyWith(customName: customName);
      return fl;
    }).toList();
  }
}
