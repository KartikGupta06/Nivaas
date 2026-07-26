import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/design_showcase/presentation/design_showcase_screen.dart';
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

      if (!authState.isAuthenticated && !isAuthRoute && !isSplashRoute && !isShowcaseRoute) {
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
      GoRoute(
        path: RouteNames.residentHome,
        builder: (context, state) => const PlaceholderView(
          title: 'Resident Workspace',
          description: 'Resident Dashboard & Core Features Foundation',
        ),
      ),
      GoRoute(
        path: RouteNames.adminHome,
        builder: (context, state) => const PlaceholderView(
          title: 'Society Admin Workspace',
          description: 'RWA Administration & Society Management Shell',
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
        path: RouteNames.designShowcase,
        builder: (context, state) => const DesignShowcaseScreen(),
      ),
    ],
  );
});
