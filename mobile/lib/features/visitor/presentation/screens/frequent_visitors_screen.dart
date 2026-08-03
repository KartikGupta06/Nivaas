import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../../shared/widgets/navigation/nivaas_avatar.dart';
import '../../domain/entities/frequent_visitor.dart';
import '../providers/visitor_providers.dart';

/// Frequent Visitors / Daily Staff Re-Entry Screen.
class FrequentVisitorsScreen extends ConsumerWidget {
  const FrequentVisitorsScreen({super.key});

  void _showQuickCheckInModal(BuildContext context, WidgetRef ref, FrequentVisitor staff) {
    final flatController = TextEditingController(text: staff.flatsAssigned.split(',').first.trim());

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: SpacingSystem.m,
          right: SpacingSystem.m,
          top: SpacingSystem.m,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + SpacingSystem.m,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Gate Pass — ${staff.name}', style: TypographyScale.headingMedium),
            const SizedBox(height: 4),
            Text('Service: ${staff.serviceType} • Phone: ${staff.phone}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
            const SizedBox(height: SpacingSystem.m),
            TextField(
              controller: flatController,
              decoration: const InputDecoration(
                labelText: 'Target Flat Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: SpacingSystem.l),
            NivaasButton.primary(
              label: 'CONFIRM STAFF ENTRY',
              icon: Icons.check_circle,
              onPressed: () async {
                final repo = ref.read(visitorRepositoryProvider);
                final log = await repo.quickCheckInFrequentVisitor(staff, flatController.text.trim());
                await ref.read(gateNotifierProvider.notifier).loadGateSummary();
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Staff ${log.visitorName} checked in for Flat ${log.flatNumber}! Pass: ${log.passCode}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequentAsync = ref.watch(frequentVisitorsProvider);

    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Daily Staff & Frequent Visitors',
        showBackButton: true,
      ),
      body: frequentAsync.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(child: Text('Error loading staff: $err', style: TypographyScale.bodyMedium)),
        data: (staffList) => ListView.separated(
          padding: const EdgeInsets.all(SpacingSystem.m),
          itemCount: staffList.length,
          separatorBuilder: (_, __) => const SizedBox(height: SpacingSystem.s),
          itemBuilder: (context, index) {
            final s = staffList[index];
            return NivaasCard(
              padding: const EdgeInsets.all(SpacingSystem.m),
              child: Row(
                children: [
                  NivaasAvatar(name: s.name, radius: 24.0),
                  const SizedBox(width: SpacingSystem.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('Role: ${s.serviceType}', style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.primary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('Assigned Flats: ${s.flatsAssigned}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                      ],
                    ),
                  ),
                  NivaasButton.primary(
                    label: 'CHECK IN',
                    icon: Icons.login,
                    isFullWidth: false,
                    onPressed: () => _showQuickCheckInModal(context, ref, s),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
