import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/routes/route_names.dart';
import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/cards/nivaas_clickable_card.dart';
import '../../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../providers/visitor_providers.dart';

/// Dedicated High-Contrast Watchman Dashboard Screen (`/watchman/home`).
class WatchmanDashboardScreen extends ConsumerWidget {
  const WatchmanDashboardScreen({super.key});

  String _formatDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _formatTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $ampm';
  }

  void _showQrNotice(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(SpacingSystem.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_scanner, size: 64.0, color: ColorPalette.primary),
            const SizedBox(height: SpacingSystem.m),
            const Text('Gate QR Scanner Architecture Ready', style: TypographyScale.headingMedium),
            const SizedBox(height: SpacingSystem.xs),
            Text(
              'Visitor and Resident fast-pass camera scanning will be active in future gate hardware release.',
              style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.l),
            NivaasButton.primary(
              label: 'Close Scanner',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gateSummaryState = ref.watch(gateNotifierProvider);

    return AppScaffold(
      appBar: NivaasAppBar(
        title: 'Gate Security Workspace',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: ColorPalette.primary),
            onPressed: () => _showQrNotice(context),
            tooltip: 'QR Gate Scanner',
          ),
          IconButton(
            icon: const Icon(Icons.history, color: ColorPalette.textPrimary),
            onPressed: () => context.push(RouteNames.visitorHistory),
            tooltip: 'Visitor History',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(gateNotifierProvider.notifier).loadGateSummary();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SpacingSystem.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Clock & Gate Banner
              NivaasCard(
                padding: const EdgeInsets.all(SpacingSystem.m),
                backgroundColor: ColorPalette.primary,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(SpacingSystem.s),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.security, color: Colors.white, size: 32.0),
                    ),
                    const SizedBox(width: SpacingSystem.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatTime(),
                            style: TypographyScale.displayLarge.copyWith(color: Colors.white),
                          ),
                          Text(
                            _formatDate(),
                            style: TypographyScale.caption.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'GATE ONLINE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              // Live Gate Summary Counters
              const Text('Live Gate Counters', style: TypographyScale.headingSmall),
              const SizedBox(height: SpacingSystem.s),

              gateSummaryState.when(
                loading: () => const NivaasLoader(),
                error: (err, _) => Text('Error loading counters: $err', style: TypographyScale.bodyMedium),
                data: (summary) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: SpacingSystem.s,
                  crossAxisSpacing: SpacingSystem.s,
                  childAspectRatio: 1.4,
                  children: [
                    _GateCounterCard(
                      label: 'Visitors Inside',
                      count: summary.visitorsInside,
                      icon: Icons.meeting_room,
                      color: ColorPalette.success,
                      onTap: () => context.push('${RouteNames.visitorHistory}?status=CHECKED_IN'),
                    ),
                    _GateCounterCard(
                      label: 'Pending Approvals',
                      count: summary.pendingApprovals,
                      icon: Icons.hourglass_top,
                      color: ColorPalette.warning,
                      onTap: () => context.push(RouteNames.visitorApproval),
                    ),
                    _GateCounterCard(
                      label: 'Visitors Exited',
                      count: summary.visitorsExited,
                      icon: Icons.exit_to_app,
                      color: ColorPalette.textSecondary,
                      onTap: () => context.push('${RouteNames.visitorHistory}?status=CHECKED_OUT'),
                    ),
                    _GateCounterCard(
                      label: 'Today Total Entries',
                      count: summary.todayTotal,
                      icon: Icons.assignment_ind,
                      color: ColorPalette.primary,
                      onTap: () => context.push(RouteNames.visitorHistory),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              // High-Speed Gate Action Buttons
              const Text('Fast Gate Actions', style: TypographyScale.headingSmall),
              const SizedBox(height: SpacingSystem.s),

              Column(
                children: [
                  NivaasButton.primary(
                    label: 'REGISTER NEW VISITOR',
                    icon: Icons.person_add_rounded,
                    onPressed: () => context.push(RouteNames.visitorRegister),
                  ),
                  const SizedBox(height: SpacingSystem.s),
                  NivaasButton.secondary(
                    label: 'DELIVERY ENTRY (Swiggy, Zomato, Amazon...)',
                    icon: Icons.local_shipping_outlined,
                    onPressed: () => context.push(RouteNames.deliveryEntry),
                  ),
                  const SizedBox(height: SpacingSystem.s),
                  Row(
                    children: [
                      Expanded(
                        child: NivaasButton.outlined(
                          label: 'Daily Staff / Frequent',
                          icon: Icons.badge_outlined,
                          isFullWidth: false,
                          onPressed: () => context.push(RouteNames.frequentVisitors),
                        ),
                      ),
                      const SizedBox(width: SpacingSystem.s),
                      Expanded(
                        child: NivaasButton.danger(
                          label: 'EMERGENCY ENTRY',
                          icon: Icons.warning_amber_rounded,
                          isFullWidth: false,
                          onPressed: () => context.push(RouteNames.emergencyEntry),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: SpacingSystem.l),

              // Pending Approvals Quick Alert Card
              gateSummaryState.maybeWhen(
                data: (summary) {
                  if (summary.pendingApprovals == 0) return const SizedBox.shrink();
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorPalette.warningContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: NivaasClickableCard(
                      onTap: () => context.push(RouteNames.visitorApproval),
                      child: Row(
                        children: [
                          const Icon(Icons.pending_actions, color: ColorPalette.warning, size: 28),
                          const SizedBox(width: SpacingSystem.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${summary.pendingApprovals} Pending Visitor Approvals',
                                  style: TypographyScale.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.warning,
                                  ),
                                ),
                                Text(
                                  'Tap to view resident approval status',
                                  style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: ColorPalette.warning),
                        ],
                      ),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),

              const SizedBox(height: SpacingSystem.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _GateCounterCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GateCounterCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NivaasClickableCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SpacingSystem.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(SpacingSystem.xs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20.0),
              ),
              const Spacer(),
              Text(
                '$count',
                style: TypographyScale.headingLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingSystem.xs),
          Text(
            label,
            style: TypographyScale.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorPalette.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
