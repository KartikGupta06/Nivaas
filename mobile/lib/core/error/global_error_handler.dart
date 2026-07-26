import 'package:flutter/foundation.dart';
import '../logging/logger_service.dart';

/// Global Uncaught Exception Handler catching Flutter framework and async errors.
class GlobalErrorHandler {
  static void initialize(LoggerService logger) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logger.error('Flutter Framework Error: ${details.exceptionAsString()}', details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.error('Platform Uncaught Exception: $error', error, stack);
      return true;
    };
  }
}
