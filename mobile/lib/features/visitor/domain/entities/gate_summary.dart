import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing Watchman Gate Live Summary Counters.
class GateSummary extends Equatable {
  final int todayTotal;
  final int visitorsInside;
  final int visitorsExited;
  final int pendingApprovals;
  final String gateName;

  const GateSummary({
    required this.todayTotal,
    required this.visitorsInside,
    required this.visitorsExited,
    required this.pendingApprovals,
    this.gateName = 'Main Gate',
  });

  factory GateSummary.fromJson(Map<String, dynamic> json) {
    return GateSummary(
      todayTotal: (json['today_total'] as num?)?.toInt() ?? 0,
      visitorsInside: (json['visitors_inside'] as num?)?.toInt() ?? 0,
      visitorsExited: (json['visitors_exited'] as num?)?.toInt() ?? 0,
      pendingApprovals: (json['pending_approvals'] as num?)?.toInt() ?? 0,
      gateName: json['gate_name'] as String? ?? 'Main Gate',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_total': todayTotal,
      'visitors_inside': visitorsInside,
      'visitors_exited': visitorsExited,
      'pending_approvals': pendingApprovals,
      'gate_name': gateName,
    };
  }

  @override
  List<Object?> get props => [todayTotal, visitorsInside, visitorsExited, pendingApprovals, gateName];
}
