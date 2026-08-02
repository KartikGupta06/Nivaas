import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/society_profile.dart';

final societyProfileProvider = StateNotifierProvider<SocietyProfileNotifier, SocietyProfile>((ref) {
  return SocietyProfileNotifier();
});

class SocietyProfileNotifier extends StateNotifier<SocietyProfile> {
  SocietyProfileNotifier() : super(SocietyProfile.initial());

  void update(SocietyProfile profile) {
    state = profile;
  }

  void reset() {
    state = SocietyProfile.initial();
  }
}
