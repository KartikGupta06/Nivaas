import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/radius_system.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_unit.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_phone_field.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';
import 'package:nivaas_mobile/shared/widgets/navigation/nivaas_avatar.dart';

class Step5OwnerAssignment extends ConsumerWidget {
  const Step5OwnerAssignment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(societySetupControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Initial Owner Assignment',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Assign initial resident owners or primary contacts to generated flats.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        ...setupState.generatedHouses.map((house) {
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
                        Text(
                          'Flat ${house.flatNumber} • ${house.wingName}',
                          style: TypographyScale.headingSmall,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          hasOwner ? '${house.ownerName} (${house.ownerPhone})' : 'Unassigned Owner',
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
                label: 'Owner Full Name',
                hintText: 'e.g. Ramesh Sharma',
                controller: nameController,
              ),
              const NivaasGap.m(),
              NivaasPhoneField(
                controller: phoneController,
              ),
              const NivaasGap.l(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  ref.read(societySetupControllerProvider.notifier).assignOwner(house.id, name, phone);
                  Navigator.pop(modalContext);
                },
                child: const Text('Save Owner Assignment', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
