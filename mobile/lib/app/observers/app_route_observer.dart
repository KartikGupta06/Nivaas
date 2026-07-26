import 'package:flutter/material.dart';
import '../../core/logging/logger_service.dart';

/// Navigation Observer for tracking screen navigation events.
class AppRouteObserver extends NavigatorObserver {
  final LoggerService _logger;

  AppRouteObserver(this._logger);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logger.info('Navigated PUSH -> ${route.settings.name ?? route.toString()}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logger.info('Navigated POP <- ${route.settings.name ?? route.toString()}');
  }
}
