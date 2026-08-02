import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_unit.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/society_profile.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_info_row.dart';
import 'package:nivaas_mobile/shared/widgets/selection/nivaas_status_chip.dart';

class Step8ReviewComplete extends ConsumerWidget {
  const Step8ReviewComplete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(societySetupControllerProvider);
    final profile = setupState.profile;
    final config = setupState.maintenanceConfig;

    final assignedCount = setupState.generatedHouses.where((h) => h.ownerName != null && h.ownerName!.isNotEmpty).length;

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Final Structure Review',
                  style: TypographyScale.headingLarge,
                ),
                SizedBox(height: SpacingSystem.xs),
                Text(
                  'Review Society → Wing → Floor → House hierarchy before final submission.',
                  style: TypographyScale.bodyMedium,
                ),
              ],
            ),
            NivaasStatusChip.approved(label: 'READY FOR SUBMIT'),
          ],
        ),
        const NivaasGap.l(),
        NivaasCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.home_work_rounded, color: ColorPalette.primary, size: 28.0),
                  const SizedBox(width: SpacingSystem.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name.isNotEmpty ? profile.name : 'Green Park Apartments RWA',
                          style: TypographyScale.headingMedium,
                        ),
                        Text(
                          '${profile.address}, ${profile.city}, ${profile.state}',
                          style: TypographyScale.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24.0, color: ColorPalette.outline),
              NivaasInfoRow(label: 'Society Category', value: profile.type.displayName),
              NivaasInfoRow(label: 'Contact Mobile', value: profile.contactNumber.isNotEmpty ? profile.contactNumber : '+91 9876543210'),
              NivaasInfoRow(
                label: 'Configured Wings',
                value: '${setupState.wings.length} Wings (${setupState.wings.map((w) => w.name).join(', ')})',
              ),
              NivaasInfoRow(label: 'Total Generated Flats', value: '${setupState.generatedHouses.length} Units'),
              NivaasInfoRow(label: 'Assigned Initial Owners', value: '$assignedCount / ${setupState.generatedHouses.length} Flats'),
              NivaasInfoRow(
                label: 'Monthly Maintenance',
                value: '₹${config.defaultAmount.toStringAsFixed(0)} (Due ${config.dueDateDay}th)',
              ),
            ],
          ),
        ),
        const NivaasGap.l(),
        const Text(
          'Hierarchy Preview (Society → Wing → House)',
          style: TypographyScale.headingMedium,
        ),
        const NivaasGap.s(),
        ...setupState.wings.map((wing) {
          final wingHouses = setupState.generatedHouses.where((h) => h.wingName == wing.name).toList();

          return Padding(
            padding: const EdgeInsets.only(bottom: SpacingSystem.m),
            child: NivaasCard(
              child: ExpansionTile(
                leading: const Icon(Icons.apartment_rounded, color: ColorPalette.primary),
                title: Text('${wing.name} (${wing.totalFloors} Floors, ${wingHouses.length} Flats)', style: TypographyScale.headingSmall),
                children: wingHouses.take(8).map((house) {
                  return ListTile(
                    dense: true,
                    title: Text('Flat ${house.flatNumber} (${house.type.displayName})'),
                    subtitle: Text(house.ownerName != null ? 'Owner: ${house.ownerName}' : 'Unassigned'),
                    trailing: Icon(
                      house.ownerName != null ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: house.ownerName != null ? ColorPalette.success : ColorPalette.textMuted,
                      size: 16.0,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }
}
