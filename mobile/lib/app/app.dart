import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_localizations.dart';
import 'config/app_config.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'providers/auth_state_provider.dart';
import 'providers/logger_provider.dart';
import 'providers/theme_provider.dart';

/// Root Application Widget for Nivaas.
class NivaasApp extends ConsumerWidget {
  const NivaasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.watch(loggerProvider);
    final authState = ref.watch(authStateProvider);
    final themeMode = ref.watch(themeProvider);

    final router = AppRouter.buildRouter(logger, authState.userRole);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
