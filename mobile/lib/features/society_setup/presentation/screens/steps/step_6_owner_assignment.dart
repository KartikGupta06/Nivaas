import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/radius_system.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_owner.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_unit.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/buttons/nivaas_button.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_dropdown.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_phone_field.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_search_field.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';
import 'package:nivaas_mobile/shared/widgets/navigation/nivaas_avatar.dart';
import 'package:nivaas_mobile/shared/widgets/selection/nivaas_status_chip.dart';

class Step6OwnerAssignment extends ConsumerStatefulWidget {
  const Step6OwnerAssignment({super.key});

  @override
  ConsumerState<Step6OwnerAssignment> createState() => _Step6OwnerAssignmentState();
}

class _Step6OwnerAssignmentState extends ConsumerState<Step6OwnerAssignment> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(societySetupControllerProvider);

    final filteredHouses = setupState.generatedHouses.where((h) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return h.flatNumber.toLowerCase().contains(q) ||
          h.wingName.toLowerCase().contains(q) ||
          (h.ownerName != null && h.ownerName!.toLowerCase().contains(q));
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Initial Owner Assignment',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Assign initial resident owners or primary contacts to generated flats. Only Admins can assign ownership.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.m(),
        NivaasSearchField(
          hintText: 'Search by Flat number, Wing, or Owner name...',
          onChanged: (val) => setState(() => _searchQuery = val),
          onClear: () => setState(() => _searchQuery = ''),
        ),
        const NivaasGap.m(),
        ...filteredHouses.map((house) {
          final hasOwner = house.ownerName != null && house.ownerName!.isNotEmpty;

          return Padding(
            padding: const EdgeInsets.only(bottom: SpacingSystem.m),
            child: NivaasCard(
              child: Row(
                children: [
                  NivaasAvatar(name: hasOwner ? house.ownerName! : house.flatNumber),
                  const SizedBox(width: SpacingSystem.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Flat ${house.flatNumber} • ${house.wingName}',
                              style: TypographyScale.headingSmall,
                            ),
                            const SizedBox(width: 6.0),
                            hasOwner
                                ? const NivaasStatusChip.approved(label: 'ASSIGNED')
                                : const NivaasStatusChip.pending(label: 'UNASSIGNED'),
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          hasOwner ? '${house.ownerName} (${house.ownerPhone})' : 'Vacant / Unassigned',
                          style: TypographyScale.bodyMedium.copyWith(
                            color: hasOwner ? ColorPalette.primary : ColorPalette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      hasOwner ? Icons.edit_rounded : Icons.person_add_alt_1_rounded,
                      color: ColorPalette.primaryAccent,
                    ),
                    onPressed: () => _showOwnerAssignModal(context, ref, house),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showOwnerAssignModal(BuildContext context, WidgetRef ref, HouseUnit house) {
    final nameController = TextEditingController(text: house.ownerName ?? '');
    final phoneController = TextEditingController(text: house.ownerPhone ?? '');
    final emailController = TextEditingController(text: house.ownerEmail ?? '');
    final emergencyController = TextEditingController(text: house.emergencyContact ?? '');
    OccupancyStatus selectedStatus = OccupancyStatus.ownerOccupied;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.bottomSheetTop),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: SpacingSystem.m,
            right: SpacingSystem.m,
            top: SpacingSystem.m,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + SpacingSystem.m,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assign Owner to Flat ${house.flatNumber}', style: TypographyScale.headingMedium),
              const NivaasGap.m(),
              NivaasTextField(
                label: 'Owner Full Name *',
                hintText: 'e.g. Ramesh Sharma',
                controller: nameController,
              ),
              const NivaasGap.m(),
              NivaasPhoneField(
                controller: phoneController,
              ),
              const NivaasGap.m(),
              NivaasTextField(
                label: 'Email (Optional)',
                hintText: 'ramesh@example.com',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const NivaasGap.m(),
              NivaasTextField(
                label: 'Emergency Contact (Optional)',
                hintText: '+91 9811223344',
                keyboardType: TextInputType.phone,
                controller: emergencyController,
              ),
              const NivaasGap.m(),
              NivaasDropdown<OccupancyStatus>(
                label: 'Occupancy Status',
                value: selectedStatus,
                items: OccupancyStatus.values
                    .map((s) => NivaasDropdownItem(value: s, label: s.displayName))
                    .toList(),
                onChanged: (val) => selectedStatus = val,
              ),
              const NivaasGap.l(),
              NivaasButton.primary(
                label: 'Save Owner Assignment',
                onPressed: () {
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final email = emailController.text.trim();
                  final emergency = emergencyController.text.trim();

                  ref.read(societySetupControllerProvider.notifier).assignOwner(
                        house.id,
                        name,
                        phone,
                        email: email.isNotEmpty ? email : null,
                        emergencyContact: emergency.isNotEmpty ? emergency : null,
                      );
                  Navigator.pop(modalContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
