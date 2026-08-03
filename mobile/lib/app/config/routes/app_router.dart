import 'package:go_router/go_router.dart';

import '../../../features/resident/presentation/screens/emergency_contacts_screen.dart';
import '../../../features/resident/presentation/screens/family_members_screen.dart';
import '../../../features/resident/presentation/screens/house_details_screen.dart';
import '../../../features/resident/presentation/screens/resident_dashboard_screen.dart';
import '../../../features/resident/presentation/screens/resident_profile_screen.dart';
import '../../../features/resident/presentation/screens/society_info_screen.dart';
import '../../../features/resident/presentation/screens/vehicles_screen.dart';
import '../../../shared/models/user_role.dart';
import '../../../shared/widgets/placeholder_view.dart';
import '../../observers/app_route_observer.dart';
import '../../../core/logging/logger_service.dart';
import 'route_names.dart';

/// Centralized Declarative GoRouter Configuration.
abstract class AppRouter {
  static GoRouter buildRouter(LoggerService logger, UserRole currentRole) {
    return GoRouter(
      initialLocation: RouteNames.splash,
      observers: [AppRouteObserver(logger)],
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (context, state) => const PlaceholderView(
            title: 'Nivaas',
            description: 'Architecture Infrastructure Shell Ready',
          ),
        ),
        GoRoute(
          path: RouteNames.auth,
          builder: (context, state) => const PlaceholderView(
            title: 'Authentication',
            description: 'OTP Verification Shell',
          ),
        ),
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
          builder: (context, state) => const PlaceholderView(
            title: 'Admin Dashboard',
            description: 'Society Admin Workspace Foundation',
          ),
        ),
        GoRoute(
          path: RouteNames.watchmanHome,
          builder: (context, state) => const PlaceholderView(
            title: 'Gate Security Stream',
            description: 'Watchman High-Contrast Workspace Foundation',
          ),
        ),
      ],
    );
  }
}
