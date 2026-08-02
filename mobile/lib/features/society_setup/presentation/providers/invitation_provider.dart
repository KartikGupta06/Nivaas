import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/invitation_link.dart';

final invitationLinkProvider = StateNotifierProvider<InvitationLinkNotifier, InvitationLink?>((ref) {
  return InvitationLinkNotifier();
});

class InvitationLinkNotifier extends StateNotifier<InvitationLink?> {
  InvitationLinkNotifier() : super(null);

  void generate(String societyId) {
    state = InvitationLink.generate(societyId);
  }
}
