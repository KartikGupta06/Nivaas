import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/auth_state_provider.dart';
import '../../../../shared/models/user_role.dart';
import '../../data/models/login_request.dart';
import 'auth_providers.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

/// AuthController orchestrating UI actions with AuthRepository & AuthState.
class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  /// Restores saved session from secure storage during App Splash initialization
  Future<bool> restoreSession() async {
    final repo = _ref.read(authRepositoryProvider);
    final notifier = _ref.read(authStateProvider.notifier);

    notifier.setLoading(true);
    try {
      final profile = await repo.restoreSession();
      if (profile != null) {
        notifier.setAuthenticated(profile);
        return true;
      } else {
        notifier.setUnauthenticated();
        return false;
      }
    } catch (e) {
      notifier.setUnauthenticated(errorMessage: e.toString());
      return false;
    }
  }

  /// Handles Login with Phone and Password
  Future<bool> loginWithPhone(String phone, String password) async {
    final repo = _ref.read(authRepositoryProvider);
    final notifier = _ref.read(authStateProvider.notifier);

    notifier.setLoading(true);
    try {
      final profile = await repo.loginWithPhone(
        LoginRequest(phone: phone, password: password),
      );
      notifier.setAuthenticated(profile);
      return true;
    } catch (e) {
      notifier.setUnauthenticated(errorMessage: e.toString());
      return false;
    }
  }

  /// Handles OTP verification
  Future<bool> verifyOtp(String phone, String otp) async {
    final repo = _ref.read(authRepositoryProvider);
    final notifier = _ref.read(authStateProvider.notifier);

    notifier.setLoading(true);
    try {
      final profile = await repo.verifyOtp(phone, otp);
      notifier.setAuthenticated(profile);
      return true;
    } catch (e) {
      notifier.setUnauthenticated(errorMessage: e.toString());
      return false;
    }
  }

  /// Handles user logout and secure token clearance
  Future<void> logout() async {
    final repo = _ref.read(authRepositoryProvider);
    final notifier = _ref.read(authStateProvider.notifier);

    notifier.setLoading(true);
    try {
      await repo.logout();
    } finally {
      notifier.setUnauthenticated();
    }
  }

  /// Development-Only Mock Role Switcher for instant role testing
  Future<void> debugSwitchRole(UserRole role) async {
    String phone = '9876543210';
    if (role == UserRole.societyAdmin) phone = '9876543211';
    if (role == UserRole.watchman) phone = '9876543212';

    await loginWithPhone(phone, '123456');
  }
}
