import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_role.dart';

/// State representation for Authentication Shell.
class AuthState {
  final bool isAuthenticated;
  final UserRole userRole;
  final String? societyId;

  const AuthState({
    required this.isAuthenticated,
    required this.userRole,
    this.societyId,
  });

  factory AuthState.unauthenticated() {
    return const AuthState(
      isAuthenticated: false,
      userRole: UserRole.none,
      societyId: null,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.unauthenticated());

  void setAuthenticated({required UserRole role, required String societyId}) {
    state = AuthState(
      isAuthenticated: true,
      userRole: role,
      societyId: societyId,
    );
  }

  void logout() {
    state = AuthState.unauthenticated();
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
