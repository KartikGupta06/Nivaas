import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/maintenance_config.dart';

final maintenanceConfigProvider = StateNotifierProvider<MaintenanceConfigNotifier, MaintenanceConfig>((ref) {
  return MaintenanceConfigNotifier();
});

class MaintenanceConfigNotifier extends StateNotifier<MaintenanceConfig> {
  MaintenanceConfigNotifier() : super(const MaintenanceConfig());

  void update({
    MaintenanceRuleType? ruleType,
    double? defaultAmount,
    int? dueDateDay,
    double? lateFeeAmount,
    int? gracePeriodDays,
  }) {
    state = state.copyWith(
      ruleType: ruleType,
      defaultAmount: defaultAmount,
      dueDateDay: dueDateDay,
      lateFeeAmount: lateFeeAmount,
      gracePeriodDays: gracePeriodDays,
    );
  }
}
