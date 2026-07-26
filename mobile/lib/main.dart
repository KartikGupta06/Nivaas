import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/error/global_error_handler.dart';
import 'core/logging/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = LoggerService(isVerbose: true);
  GlobalErrorHandler.initialize(logger);

  logger.info('Initializing Nivaas Mobile Foundation Phase 00...');

  runApp(
    const ProviderScope(
      child: NivaasApp(),
    ),
  );
}
