import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/radius_system.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/invitation_link.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';
import 'package:nivaas_mobile/shared/widgets/selection/nivaas_status_chip.dart';

class Step7InvitationFlow extends ConsumerWidget {
  const Step7InvitationFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(societySetupControllerProvider);
    final societyId = setupState.profile.id.isNotEmpty ? setupState.profile.id : 'soc_demo_999';
    final invitation = InvitationLink.generate(societyId);

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Resident Invitation Architecture',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Generate and architecture-verify digital invitation links for upcoming resident onboarding.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        NivaasCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.mark_email_read_rounded, color: ColorPalette.primary, size: 28.0),
                      SizedBox(width: SpacingSystem.m),
                      Text('Society Invite Link', style: TypographyScale.headingMedium),
                    ],
                  ),
                  NivaasStatusChip.approved(label: 'ARCH READY'),
                ],
              ),
              const Divider(height: 24.0, color: ColorPalette.outline),
              Container(
                padding: const EdgeInsets.all(SpacingSystem.m),
                decoration: BoxDecoration(
                  color: ColorPalette.surfaceSubtle,
                  borderRadius: RadiusSystem.radiusM,
                  border: Border.all(color: ColorPalette.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        invitation.deepLinkUrl,
                        style: TypographyScale.bodyMedium.copyWith(
                          fontFamily: 'monospace',
                          color: ColorPalette.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: ColorPalette.primary),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: invitation.deepLinkUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invite link copied to clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const NivaasGap.m(),
              const Text('Supported Dispatch Channels:', style: TypographyScale.caption),
              const SizedBox(height: SpacingSystem.xs),
              Wrap(
                spacing: SpacingSystem.s,
                children: invitation.supportedChannels.map((channel) {
                  return Chip(
                    avatar: Icon(
                      channel == 'SMS'
                          ? Icons.sms_rounded
                          : channel == 'WhatsApp'
                              ? Icons.chat_rounded
                              : Icons.email_rounded,
                      size: 16.0,
                      color: ColorPalette.primary,
                    ),
                    label: Text(channel, style: TypographyScale.caption),
                    backgroundColor: ColorPalette.primaryContainer,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
