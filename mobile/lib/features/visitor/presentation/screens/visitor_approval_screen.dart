import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/feedback/nivaas_empty_state.dart';
import '../../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../../shared/widgets/navigation/nivaas_avatar.dart';
import '../../../../shared/widgets/selection/nivaas_status_chip.dart';
import '../providers/visitor_providers.dart';

/// Resident / Guard Visitor Approval Queue Screen.
class VisitorApprovalScreen extends ConsumerWidget {
  const VisitorApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingState = ref.watch(approvalNotifierProvider);

    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Pending Visitor Approvals',
        showBackButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(approvalNotifierProvider.notifier).loadPendingApprovals();
        },
        child: pendingState.when(
          loading: () => const NivaasLoader(),
          error: (err, _) => Center(child: Text('Failed to load pending approvals: $err', style: TypographyScale.bodyMedium)),
          data: (pendingLogs) {
            if (pendingLogs.isEmpty) {
              return const NivaasEmptyState(
                icon: Icons.check_circle_outline,
                title: 'No Pending Approvals',
                message: 'All visitor entries have been processed.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(SpacingSystem.m),
              itemCount: pendingLogs.length,
              separatorBuilder: (_, __) => const SizedBox(height: SpacingSystem.s),
              itemBuilder: (context, index) {
                final log = pendingLogs[index];

                return NivaasCard(
                  padding: const EdgeInsets.all(SpacingSystem.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NivaasAvatar(name: log.visitorName, radius: 24.0),
                          const SizedBox(width: SpacingSystem.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.visitorName, style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                Text('Destination: ${log.wingName} - Flat ${log.flatNumber}', style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.primary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const NivaasStatusChip.pending(label: 'WAITING'),
                        ],
                      ),
                      const SizedBox(height: SpacingSystem.s),
                      Text('Purpose: ${log.purpose}', style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary)),
                      Text('Phone: ${log.visitorPhone}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                      Text('Gate Check-in Time: ${log.checkInTime}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                      const SizedBox(height: SpacingSystem.m),

                      Row(
                        children: [
                          Expanded(
                            child: NivaasButton.danger(
                              label: 'REJECT ENTRY',
                              icon: Icons.close,
                              isFullWidth: false,
                              onPressed: () async {
                                final success = await ref.read(approvalNotifierProvider.notifier).respondToApproval(log.id, false);
                                await ref.read(gateNotifierProvider.notifier).loadGateSummary();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success ? 'Visitor ${log.visitorName} entry rejected.' : 'Action failed.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: SpacingSystem.m),
                          Expanded(
                            child: NivaasButton.primary(
                              label: 'APPROVE ENTRY',
                              icon: Icons.check,
                              isFullWidth: false,
                              onPressed: () async {
                                final success = await ref.read(approvalNotifierProvider.notifier).respondToApproval(log.id, true);
                                await ref.read(gateNotifierProvider.notifier).loadGateSummary();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success ? 'Visitor ${log.visitorName} APPROVED! Pass: ${log.passCode}' : 'Action failed.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
