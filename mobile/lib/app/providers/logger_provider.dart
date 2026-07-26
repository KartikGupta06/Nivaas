import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logging/logger_service.dart';

/// Provider for global LoggerService instance.
final loggerProvider = Provider<LoggerService>((ref) {
  return LoggerService(isVerbose: true);
});
