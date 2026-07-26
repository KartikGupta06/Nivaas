import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/user_profile.dart';
import '../../shared/models/user_role.dart';

/// Comprehensive State Representation for Authentication Engine.
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserRole userRole;
  final UserProfile? userProfile;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    required this.isAuthenticated,
    required this.userRole,
    this.userProfile,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: true,
      isAuthenticated: false,
      userRole: UserRole.none,
    );
  }

  factory AuthState.unauthenticated({String? errorMessage}) {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      userRole: UserRole.none,
      errorMessage: errorMessage,
    );
  }

  factory AuthState.authenticated(UserProfile profile) {
    return AuthState(
      isLoading: false,
      isAuthenticated: true,
      userRole: profile.role,
      userProfile: profile,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserRole? userRole,
    UserProfile? userProfile,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading, errorMessage: null);
  }

  void setAuthenticated(UserProfile profile) {
    state = AuthState.authenticated(profile);
  }

  void setUnauthenticated({String? errorMessage}) {
    state = AuthState.unauthenticated(errorMessage: errorMessage);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
