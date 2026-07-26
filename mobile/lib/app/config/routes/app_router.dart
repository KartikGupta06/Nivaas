import 'package:go_router/go_router.dart';

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
          builder: (context, state) => const PlaceholderView(
            title: 'Resident Dashboard',
            description: 'Resident Workspace Foundation',
          ),
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
