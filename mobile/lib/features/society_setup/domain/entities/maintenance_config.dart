import 'package:equatable/equatable.dart';

enum MaintenanceRuleType {
  fixed,
  formulaBased,
  areaBased,
}

extension MaintenanceRuleTypeX on MaintenanceRuleType {
  String get displayName {
    switch (this) {
      case MaintenanceRuleType.fixed:
        return 'Fixed Flat Rate';
      case MaintenanceRuleType.formulaBased:
        return 'Formula Based';
      case MaintenanceRuleType.areaBased:
        return 'Per Sq Ft Area Based';
    }
  }
}

/// Pure Domain Entity representing Society Maintenance Configuration.
class MaintenanceConfig extends Equatable {
  final MaintenanceRuleType ruleType;
  final double defaultAmount;
  final int dueDateDay; // 1 to 28
  final double lateFeeAmount;
  final int gracePeriodDays;

  const MaintenanceConfig({
    this.ruleType = MaintenanceRuleType.fixed,
    this.defaultAmount = 2500.0,
    this.dueDateDay = 5,
    this.lateFeeAmount = 0.0,
    this.gracePeriodDays = 0,
  });

  MaintenanceConfig copyWith({
    MaintenanceRuleType? ruleType,
    double? defaultAmount,
    int? dueDateDay,
    double? lateFeeAmount,
    int? gracePeriodDays,
  }) {
    return MaintenanceConfig(
      ruleType: ruleType ?? this.ruleType,
      defaultAmount: defaultAmount ?? this.defaultAmount,
      dueDateDay: dueDateDay ?? this.dueDateDay,
      lateFeeAmount: lateFeeAmount ?? this.lateFeeAmount,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rule_type': ruleType.name,
      'default_amount': defaultAmount,
      'due_date_day': dueDateDay,
      'late_fee_amount': lateFeeAmount,
      'grace_period_days': gracePeriodDays,
    };
  }

  factory MaintenanceConfig.fromJson(Map<String, dynamic> json) {
    return MaintenanceConfig(
      ruleType: MaintenanceRuleType.values.firstWhere(
        (e) => e.name == json['rule_type'],
        orElse: () => MaintenanceRuleType.fixed,
      ),
      defaultAmount: (json['default_amount'] as num?)?.toDouble() ?? 2500.0,
      dueDateDay: json['due_date_day'] as int? ?? 5,
      lateFeeAmount: (json['late_fee_amount'] as num?)?.toDouble() ?? 0.0,
      gracePeriodDays: json['grace_period_days'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [ruleType, defaultAmount, dueDateDay, lateFeeAmount, gracePeriodDays];
}
