import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../config/env_config.dart';

/// Provider for active AppConfig.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(envConfig: EnvConfig.development());
});
