import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../../shared/widgets/inputs/nivaas_text_field.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../../shared/widgets/navigation/nivaas_avatar.dart';
import '../../../../shared/widgets/navigation/nivaas_list_tile.dart';
import '../../domain/entities/resident_profile.dart';
import '../providers/resident_providers.dart';

/// Resident Profile View & Edit Screen.
class ResidentProfileScreen extends ConsumerWidget {
  const ResidentProfileScreen({super.key});

  void _showEditModal(BuildContext context, WidgetRef ref, ResidentProfile current) {
    final nameController = TextEditingController(text: current.fullName);
    final emailController = TextEditingController(text: current.email ?? '');
    final emergencyController = TextEditingController(text: current.emergencyContact ?? '');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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
            const Text('Edit Resident Profile', style: TypographyScale.headingMedium),
            const SizedBox(height: SpacingSystem.m),
            NivaasTextField(
              controller: nameController,
              label: 'Full Name',
              hintText: 'Enter your full name',
            ),
            const SizedBox(height: SpacingSystem.s),
            NivaasTextField(
              controller: emailController,
              label: 'Email Address',
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: SpacingSystem.s),
            NivaasTextField(
              controller: emergencyController,
              label: 'Emergency Contact Number',
              hintText: 'Enter emergency contact phone',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: SpacingSystem.l),
            NivaasButton.primary(
              label: 'Save Changes',
              onPressed: () async {
                final updated = current.copyWith(
                  fullName: nameController.text.trim(),
                  email: emailController.text.trim(),
                  emergencyContact: emergencyController.text.trim(),
                );
                final success = await ref.read(profileNotifierProvider.notifier).updateProfile(updated);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Profile updated successfully!' : 'Failed to update profile.'),
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
    final profileState = ref.watch(profileNotifierProvider);

    return AppScaffold(
      appBar: NivaasAppBar(
        title: 'Resident Profile',
        showBackButton: true,
        actions: [
          profileState.maybeWhen(
            data: (profile) => IconButton(
              icon: const Icon(Icons.edit_outlined, color: ColorPalette.primary),
              onPressed: () => _showEditModal(context, ref, profile),
              tooltip: 'Edit Profile',
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: profileState.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(
          child: Text('Failed to load profile: $err', style: TypographyScale.bodyMedium),
        ),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(SpacingSystem.m),
          child: Column(
            children: [
              // Avatar & Basic Info Container
              Center(
                child: Column(
                  children: [
                    NivaasAvatar(
                      name: profile.fullName,
                      imageUrl: profile.avatarUrl,
                      radius: 48.0,
                    ),
                    const SizedBox(height: SpacingSystem.s),
                    Text(
                      profile.fullName,
                      style: TypographyScale.headingMedium,
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        profile.role,
                        style: TypographyScale.caption.copyWith(
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              // Contact & Assignment Information
              NivaasCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    NivaasListTile(
                      leading: const Icon(Icons.phone_outlined, color: ColorPalette.primary),
                      title: 'Phone Number',
                      subtitle: profile.phone,
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.email_outlined, color: ColorPalette.primary),
                      title: 'Email Address',
                      subtitle: profile.email ?? 'Not provided',
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.contact_phone_outlined, color: ColorPalette.primary),
                      title: 'Personal Emergency Contact',
                      subtitle: profile.emergencyContact ?? 'Not provided',
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.home_work_outlined, color: ColorPalette.primary),
                      title: 'House Assignment',
                      subtitle: profile.houseAssignment ?? 'Flat A-402',
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.location_on_outlined, color: ColorPalette.primary),
                      title: 'Registered Address',
                      subtitle: profile.fullAddress ?? 'Dwarka, New Delhi',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              NivaasButton.outlined(
                label: 'Edit Personal Details',
                icon: Icons.edit,
                onPressed: () => _showEditModal(context, ref, profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
