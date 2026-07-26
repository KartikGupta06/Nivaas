import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/placeholder_view.dart';
import '../config/routes/route_names.dart';
import '../observers/app_route_observer.dart';
import 'auth_state_provider.dart';
import 'logger_provider.dart';

/// Riverpod Memoized Router Provider preventing router re-instantiation on widget rebuilds.
final routerProvider = Provider<GoRouter>((ref) {
  final logger = ref.watch(loggerProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    observers: [AppRouteObserver(logger)],
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuthRoute = state.matchedLocation == RouteNames.auth;
      final isSplashRoute = state.matchedLocation == RouteNames.splash;

      if (!authState.isAuthenticated && !isAuthRoute && !isSplashRoute) {
        return RouteNames.auth;
      }
      return null;
    },
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
});
