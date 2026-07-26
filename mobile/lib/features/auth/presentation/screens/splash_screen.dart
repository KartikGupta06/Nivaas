import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/routes/route_names.dart';
import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../app/providers/auth_state_provider.dart';
import '../../../../shared/models/user_role.dart';

import '../providers/auth_controller.dart';

/// Professional Splash Screen handling initialization, session restoration, and role resolution.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Artificial minimum delay for smooth brand splash
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final authController = ref.read(authControllerProvider);
    final isAuthenticated = await authController.restoreSession();

    if (!mounted) return;

    if (isAuthenticated) {
      final authState = ref.read(authStateProvider);
      _navigateForRole(authState.userRole);
    } else {
      context.go(RouteNames.auth);
    }
  }

  void _navigateForRole(UserRole role) {
    switch (role) {
      case UserRole.societyAdmin:
        context.go(RouteNames.adminHome);
        break;
      case UserRole.watchman:
        context.go(RouteNames.watchmanHome);
        break;
      case UserRole.resident:
      default:
        context.go(RouteNames.residentHome);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(SpacingSystem.l),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_work_rounded,
                size: 64.0,
                color: ColorPalette.primary,
              ),
            ),
            const SizedBox(height: SpacingSystem.l),
            Text(
              'Nivaas',
              style: TypographyScale.displayLarge.copyWith(
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: SpacingSystem.xs),
            Text(
              'Society Management Made Simple',
              style: TypographyScale.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: SpacingSystem.xxl),
            const SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
