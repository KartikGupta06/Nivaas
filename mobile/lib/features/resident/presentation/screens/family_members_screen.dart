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
import '../../../../shared/widgets/inputs/nivaas_text_field.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../../shared/widgets/navigation/nivaas_avatar.dart';
import '../../domain/entities/family_member.dart';
import '../providers/resident_providers.dart';

/// Family Members Screen for Phase 04.
class FamilyMembersScreen extends ConsumerWidget {
  const FamilyMembersScreen({super.key});

  void _showAddMemberModal(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final phoneController = TextEditingController();
    bool isChild = false;
    bool isSenior = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) => Padding(
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
              const Text('Add Family Member', style: TypographyScale.headingMedium),
              const SizedBox(height: SpacingSystem.m),
              NivaasTextField(
                controller: nameController,
                label: 'Full Name',
                hintText: 'Enter member name',
              ),
              const SizedBox(height: SpacingSystem.s),
              NivaasTextField(
                controller: relationController,
                label: 'Relationship',
                hintText: 'e.g. Spouse, Son, Daughter, Parent',
              ),
              const SizedBox(height: SpacingSystem.s),
              NivaasTextField(
                controller: phoneController,
                label: 'Contact Number (Optional)',
                hintText: 'Enter 10-digit phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: SpacingSystem.s),
              CheckboxListTile(
                title: const Text('Is Child (< 18 yrs)'),
                value: isChild,
                onChanged: (val) => setStateModal(() => isChild = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Is Senior Citizen (> 60 yrs)'),
                value: isSenior,
                onChanged: (val) => setStateModal(() => isSenior = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: SpacingSystem.l),
              NivaasButton.primary(
                label: 'Add Member',
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) return;
                  final newMember = FamilyMember(
                    id: 'fam_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    relationship: relationController.text.trim().isEmpty ? 'Family Member' : relationController.text.trim(),
                    role: isChild ? 'Children' : (isSenior ? 'Senior Citizen' : 'Family Member'),
                    contactNumber: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                    isChild: isChild,
                    isSeniorCitizen: isSenior,
                  );
                  final success = await ref.read(familyNotifierProvider.notifier).addFamilyMember(newMember);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Family member added!' : 'Failed to add member.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyState = ref.watch(familyNotifierProvider);

    return AppScaffold(
      appBar: NivaasAppBar(
        title: 'Family Members',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined, color: ColorPalette.primary),
            onPressed: () => _showAddMemberModal(context, ref),
            tooltip: 'Add Family Member',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberModal(context, ref),
        backgroundColor: ColorPalette.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Member', style: TextStyle(color: Colors.white)),
      ),
      body: familyState.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(
          child: Text('Failed to load family members: $err', style: TypographyScale.bodyMedium),
        ),
        data: (members) {
          if (members.isEmpty) {
            return NivaasEmptyState(
              icon: Icons.people_outline,
              title: 'No Family Members Listed',
              message: 'Add your family members to give them resident access and notifications.',
              actionLabel: 'Add Family Member',
              onActionPressed: () => _showAddMemberModal(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(SpacingSystem.m),
            itemCount: members.length,
            separatorBuilder: (_, __) => const SizedBox(height: SpacingSystem.s),
            itemBuilder: (context, index) {
              final m = members[index];
              return NivaasCard(
                padding: const EdgeInsets.all(SpacingSystem.m),
                child: Row(
                  children: [
                    NivaasAvatar(name: m.name, radius: 24.0),
                    const SizedBox(width: SpacingSystem.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(m.name, style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(width: SpacingSystem.xs),
                              if (m.isChild)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Child', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                                ),
                              if (m.isSeniorCitizen)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Senior', style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text('${m.relationship} • ${m.role}', style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary)),
                          if (m.contactNumber != null) ...[
                            const SizedBox(height: 4.0),
                            Text(m.contactNumber!, style: TypographyScale.caption.copyWith(color: ColorPalette.primary)),
                          ],
                        ],
                      ),
                    ),
                    if (m.contactNumber != null)
                      IconButton(
                        icon: const Icon(Icons.phone_outlined, color: ColorPalette.primary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling ${m.name} (${m.contactNumber})...'), behavior: SnackBarBehavior.floating),
                          );
                        },
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
