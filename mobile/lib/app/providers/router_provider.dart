import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/design_showcase/presentation/design_showcase_screen.dart';
import '../../features/resident/presentation/screens/emergency_contacts_screen.dart';
import '../../features/resident/presentation/screens/family_members_screen.dart';
import '../../features/resident/presentation/screens/house_details_screen.dart';
import '../../features/resident/presentation/screens/resident_dashboard_screen.dart';
import '../../features/resident/presentation/screens/resident_profile_screen.dart';
import '../../features/resident/presentation/screens/society_info_screen.dart';
import '../../features/resident/presentation/screens/vehicles_screen.dart';
import '../../features/society_setup/presentation/screens/society_setup_wizard_screen.dart';
import '../../shared/widgets/buttons/nivaas_button.dart';
import '../../shared/widgets/placeholder_view.dart';

import '../config/routes/route_names.dart';
import '../observers/app_route_observer.dart';
import 'auth_state_provider.dart';
import 'logger_provider.dart';

/// Declarative GoRouter Provider with Auth & Role Navigation Guards.
final routerProvider = Provider<GoRouter>((ref) {
  final logger = ref.watch(loggerProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    observers: [AppRouteObserver(logger)],
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuthRoute = state.matchedLocation == RouteNames.auth;
      final isSplashRoute = state.matchedLocation == RouteNames.splash;
      final isShowcaseRoute = state.matchedLocation == RouteNames.designShowcase;
      final isSetupRoute = state.matchedLocation == RouteNames.societySetup;

      if (!authState.isAuthenticated && !isAuthRoute && !isSplashRoute && !isShowcaseRoute && !isSetupRoute) {
        return RouteNames.auth;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.auth,
        builder: (context, state) => const LoginScreen(),
      ),

      // Resident Module Routes (Phase 04)
      GoRoute(
        path: RouteNames.residentHome,
        builder: (context, state) => const ResidentDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.houseDetails,
        builder: (context, state) => const HouseDetailsScreen(),
      ),
      GoRoute(
        path: RouteNames.residentProfile,
        builder: (context, state) => const ResidentProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.familyMembers,
        builder: (context, state) => const FamilyMembersScreen(),
      ),
      GoRoute(
        path: RouteNames.residentVehicles,
        builder: (context, state) => const VehiclesScreen(),
      ),
      GoRoute(
        path: RouteNames.emergencyContacts,
        builder: (context, state) => const EmergencyContactsScreen(),
      ),
      GoRoute(
        path: RouteNames.societyInfo,
        builder: (context, state) => const SocietyInfoScreen(),
      ),

      GoRoute(
        path: RouteNames.adminHome,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Society Admin Workspace')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.domain_add_rounded, size: 64, color: Color(0xFF2563EB)),
                  const SizedBox(height: 16),
                  const Text(
                    'Society Onboarding Ready',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Digitally set up your housing society, wings, floor layout engine, and initial owner assignments.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  NivaasButton.primary(
                    label: 'Start Society Setup Wizard',
                    onPressed: () => context.go(RouteNames.societySetup),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.watchmanHome,
        builder: (context, state) => const PlaceholderView(
          title: 'Gate Security Stream',
          description: 'High-Contrast Gate Entry Check-in Shell',
        ),
      ),
      GoRoute(
        path: RouteNames.societySetup,
        builder: (context, state) => const SocietySetupWizardScreen(),
      ),
      GoRoute(
        path: RouteNames.designShowcase,
        builder: (context, state) => const DesignShowcaseScreen(),
      ),
    ],
  );
});
