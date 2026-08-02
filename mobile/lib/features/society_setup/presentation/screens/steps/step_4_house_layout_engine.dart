import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/radius_system.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/house_unit.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/buttons/nivaas_button.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';
import 'package:nivaas_mobile/shared/widgets/selection/nivaas_status_chip.dart';

class Step4HouseLayoutEngine extends ConsumerWidget {
  const Step4HouseLayoutEngine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(societySetupControllerProvider);

    final groupedByWing = <String, List<HouseUnit>>{};
    for (final house in setupState.generatedHouses) {
      groupedByWing.putIfAbsent(house.wingName, () => []).add(house);
    }

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'House Layout Engine',
                  style: TypographyScale.headingLarge,
                ),
                const SizedBox(height: SpacingSystem.xs),
                Text(
                  'Auto-generated ${setupState.generatedHouses.length} flats across ${setupState.wings.length} wings.',
                  style: TypographyScale.bodyMedium,
                ),
              ],
            ),
            const NivaasStatusChip.approved(label: 'ENGINE ACTIVE'),
          ],
        ),
        const NivaasGap.l(),
        ...groupedByWing.entries.map((entry) {
          final wingName = entry.key;
          final houses = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: SpacingSystem.l),
            child: NivaasCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_city_rounded, color: ColorPalette.primary),
                      const SizedBox(width: SpacingSystem.s),
                      Text(
                        '$wingName Layout',
                        style: TypographyScale.headingMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${houses.length} Flats',
                        style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary),
                      ),
                    ],
                  ),
                  const Divider(height: 24.0, color: ColorPalette.outline),
                  Wrap(
                    spacing: SpacingSystem.s,
                    runSpacing: SpacingSystem.s,
                    children: houses.map((house) {
                      return InkWell(
                        onTap: () => _showHouseEditSheet(context, ref, house),
                        borderRadius: RadiusSystem.radiusM,
                        child: Container(
                          width: 105.0,
                          padding: const EdgeInsets.all(SpacingSystem.s),
                          decoration: BoxDecoration(
                            color: house.isCustomized ? ColorPalette.primaryContainer : ColorPalette.surfaceSubtle,
                            borderRadius: RadiusSystem.radiusM,
                            border: Border.all(
                              color: house.isCustomized ? ColorPalette.primary : ColorPalette.outline,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                house.flatNumber,
                                style: TypographyScale.headingSmall.copyWith(
                                  color: ColorPalette.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                house.type.displayName,
                                style: TypographyScale.caption.copyWith(
                                  color: ColorPalette.textSecondary,
                                  fontSize: 10.0,
                                ),
                              ),
                              if (house.areaSqFt != null)
                                Text(
                                  '${house.areaSqFt!.toStringAsFixed(0)} sqft',
                                  style: TypographyScale.caption.copyWith(
                                    color: ColorPalette.textMuted,
                                    fontSize: 9.0,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showHouseEditSheet(BuildContext context, WidgetRef ref, HouseUnit house) {
    final controller = ref.read(societySetupControllerProvider.notifier);
    final areaController = TextEditingController(text: house.areaSqFt?.toStringAsFixed(0) ?? '');
    final parkingController = TextEditingController(text: house.parkingSlot ?? '');

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
              Text('Configure Flat ${house.flatNumber} (${house.wingName})', style: TypographyScale.headingMedium),
              const SizedBox(height: SpacingSystem.m),
              const Text('House Configuration Type', style: TypographyScale.caption),
              const SizedBox(height: SpacingSystem.xs),
              Wrap(
                spacing: SpacingSystem.s,
                children: HouseType.values.map((type) {
                  final isSelected = house.type == type;
                  return ChoiceChip(
                    label: Text(type.displayName),
                    selected: isSelected,
                    selectedColor: ColorPalette.primaryContainer,
                    onSelected: (_) {
                      controller.updateHouseType(house.id, type);
                      Navigator.pop(modalContext);
                    },
                  );
                }).toList(),
              ),
              const NivaasGap.m(),
              Row(
                children: [
                  Expanded(
                    child: NivaasTextField(
                      label: 'Area (sq ft)',
                      hintText: 'e.g. 1450',
                      keyboardType: TextInputType.number,
                      controller: areaController,
                    ),
                  ),
                  const SizedBox(width: SpacingSystem.m),
                  Expanded(
                    child: NivaasTextField(
                      label: 'Parking Slot (Future)',
                      hintText: 'e.g. P-12',
                      controller: parkingController,
                    ),
                  ),
                ],
              ),
              const NivaasGap.l(),
              NivaasButton.primary(
                label: 'Save Configuration',
                onPressed: () {
                  final sqFt = double.tryParse(areaController.text.trim());
                  final parking = parkingController.text.trim();
                  controller.updateHouseDetails(
                    house.id,
                    areaSqFt: sqFt,
                    parkingSlot: parking.isNotEmpty ? parking : null,
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
