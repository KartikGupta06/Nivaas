import 'package:flutter/widgets.dart';
import '../logging/logger_service.dart';

/// Service inspecting App Lifecycle State transitions.
class AppLifecycleService with WidgetsBindingObserver {
  final LoggerService _logger;

  AppLifecycleService(this._logger);

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _logger.info('App Lifecycle State: RESUMED');
        break;
      case AppLifecycleState.inactive:
        _logger.info('App Lifecycle State: INACTIVE');
        break;
      case AppLifecycleState.paused:
        _logger.info('App Lifecycle State: PAUSED');
        break;
      case AppLifecycleState.detached:
        _logger.info('App Lifecycle State: DETACHED');
        break;
      case AppLifecycleState.hidden:
        _logger.info('App Lifecycle State: HIDDEN');
        break;
    }
  }
}
