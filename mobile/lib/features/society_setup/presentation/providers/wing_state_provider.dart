import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wing_config.dart';

final wingListProvider = StateNotifierProvider<WingListNotifier, List<WingConfig>>((ref) {
  return WingListNotifier();
});

class WingListNotifier extends StateNotifier<List<WingConfig>> {
  WingListNotifier()
      : super(const [
          WingConfig(id: 'wing_a', name: 'Wing A', totalFloors: 4, flatsPerFloor: 4, displayOrder: 0),
          WingConfig(id: 'wing_b', name: 'Wing B', totalFloors: 4, flatsPerFloor: 4, displayOrder: 1),
        ]);

  void addWing(String name) {
    if (name.trim().isEmpty) return;
    final newWing = WingConfig(
      id: 'wing_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      totalFloors: 4,
      flatsPerFloor: 4,
      displayOrder: state.length,
    );
    state = [...state, newWing];
  }

  void removeWing(String id) {
    state = state.where((w) => w.id != id).toList();
  }

  void renameWing(String id, String newName) {
    state = state.map((w) {
      if (w.id == id) return w.copyWith(name: newName.trim());
      return w;
    }).toList();
  }

  void updateConfig(String id, {int? floors, int? flatsPerFloor, int? basementFloors, bool? hasTerrace}) {
    state = state.map((w) {
      if (w.id == id) {
        return w.copyWith(
          totalFloors: floors ?? w.totalFloors,
          flatsPerFloor: flatsPerFloor ?? w.flatsPerFloor,
          basementFloors: basementFloors ?? w.basementFloors,
          hasTerrace: hasTerrace ?? w.hasTerrace,
        );
      }
      return w;
    }).toList();
  }

  void reorderWings(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final updated = List<WingConfig>.from(state);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    // Update display orders
    state = updated.asMap().entries.map((e) => e.value.copyWith(displayOrder: e.key)).toList();
  }

  void setWings(List<WingConfig> wings) {
    state = wings;
  }
}
