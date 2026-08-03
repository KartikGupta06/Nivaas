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
import '../../domain/entities/emergency_contact.dart';
import '../providers/resident_providers.dart';

/// Emergency Contacts Screen with One-Tap Call UI.
class EmergencyContactsScreen extends ConsumerWidget {
  const EmergencyContactsScreen({super.key});

  IconData _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'SECURITY':
        return Icons.security;
      case 'OFFICE':
        return Icons.business;
      case 'ELECTRICIAN':
        return Icons.bolt;
      case 'PLUMBER':
        return Icons.water_drop;
      case 'FIRE':
        return Icons.local_fire_department;
      case 'AMBULANCE':
        return Icons.medical_services;
      case 'POLICE':
        return Icons.local_police;
      default:
        return Icons.phone_in_talk;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'FIRE':
      case 'AMBULANCE':
      case 'POLICE':
        return ColorPalette.error;
      case 'SECURITY':
      case 'OFFICE':
        return ColorPalette.primary;
      case 'ELECTRICIAN':
        return Colors.orange;
      case 'PLUMBER':
        return Colors.teal;
      default:
        return ColorPalette.primary;
    }
  }

  void _triggerOneTapCall(BuildContext context, EmergencyContact contact) {
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
            Container(
              padding: const EdgeInsets.all(SpacingSystem.m),
              decoration: BoxDecoration(
                color: _getCategoryColor(contact.category).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(contact.category),
                color: _getCategoryColor(contact.category),
                size: 36.0,
              ),
            ),
            const SizedBox(height: SpacingSystem.m),
            Text(contact.designation, style: TypographyScale.headingMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4.0),
            Text(contact.name, style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary)),
            const SizedBox(height: SpacingSystem.s),
            Text(
              contact.phone,
              style: TypographyScale.headingLarge.copyWith(color: ColorPalette.primary, letterSpacing: 1.2),
            ),
            const SizedBox(height: SpacingSystem.l),
            Row(
              children: [
                Expanded(
                  child: NivaasButton.outlined(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                const SizedBox(width: SpacingSystem.m),
                Expanded(
                  child: NivaasButton.primary(
                    label: 'Call Now',
                    icon: Icons.call,
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Dialing ${contact.designation} (${contact.phone})...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(emergencyContactsProvider);

    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Emergency Contacts',
        showBackButton: true,
      ),
      body: contactsAsync.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(
          child: Text('Failed to load emergency contacts: $err', style: TypographyScale.bodyMedium),
        ),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const NivaasEmptyState(
              icon: Icons.contact_phone_outlined,
              title: 'No Emergency Contacts Found',
              message: 'Society emergency directory is being updated by your society admin.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(SpacingSystem.m),
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: SpacingSystem.s),
            itemBuilder: (context, index) {
              final c = contacts[index];
              final iconColor = _getCategoryColor(c.category);

              return NivaasCard(
                padding: const EdgeInsets.all(SpacingSystem.m),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(SpacingSystem.s),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getCategoryIcon(c.category), color: iconColor, size: 28.0),
                    ),
                    const SizedBox(width: SpacingSystem.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.designation, style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4.0),
                          Text(c.name, style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary)),
                          const SizedBox(height: 4.0),
                          Text(c.phone, style: TypographyScale.caption.copyWith(color: ColorPalette.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    NivaasButton.primary(
                      label: 'CALL',
                      icon: Icons.call,
                      isFullWidth: false,
                      onPressed: () => _triggerOneTapCall(context, c),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
