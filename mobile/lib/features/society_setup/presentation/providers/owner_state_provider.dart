import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/house_owner.dart';

final ownerListProvider = StateNotifierProvider<OwnerListNotifier, List<HouseOwner>>((ref) {
  return OwnerListNotifier();
});

class OwnerListNotifier extends StateNotifier<List<HouseOwner>> {
  OwnerListNotifier() : super(const []);

  bool addOrUpdateOwner(HouseOwner owner) {
    // Check validation
    if (!owner.isValidPhone) return false;

    // Check duplicate phone for different flat
    final duplicate = state.any((o) => o.phone == owner.phone && o.flatNumber != owner.flatNumber);
    if (duplicate) return false;

    state = [...state.where((o) => o.flatNumber != owner.flatNumber), owner];
    return true;
  }

  void removeOwner(String flatNumber) {
    state = state.where((o) => o.flatNumber != flatNumber).toList();
  }
}
