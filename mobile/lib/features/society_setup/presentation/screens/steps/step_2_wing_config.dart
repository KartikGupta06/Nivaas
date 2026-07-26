import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/radius_system.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/buttons/nivaas_button.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';

class Step2WingConfig extends ConsumerStatefulWidget {
  const Step2WingConfig({super.key});

  @override
  ConsumerState<Step2WingConfig> createState() => _Step2WingConfigState();
}

class _Step2WingConfigState extends ConsumerState<Step2WingConfig> {
  final _newWingController = TextEditingController();

  @override
  void dispose() {
    _newWingController.dispose();
    super.dispose();
  }

  void _handleAddWing() {
    final name = _newWingController.text.trim();
    if (name.isNotEmpty) {
      ref.read(societySetupControllerProvider.notifier).addWing(name);
      _newWingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(societySetupControllerProvider);
    final controller = ref.watch(societySetupControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Wing & Floor Configuration',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Add wings (blocks) and specify total floors and flats per floor for layout generation.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: NivaasTextField(
                label: 'Add New Wing / Block',
                hintText: 'e.g. Wing C, Tower 1',
                controller: _newWingController,
              ),
            ),
            const SizedBox(width: SpacingSystem.m),
            NivaasButton.primary(
              label: 'Add',
              onPressed: _handleAddWing,
              isFullWidth: false,
              icon: Icons.add,
            ),
          ],
        ),
        const NivaasGap.l(),
        const Text(
          'Configured Wings',
          style: TypographyScale.headingMedium,
        ),
        const NivaasGap.s(),
        ...setupState.wings.map((wing) {
          return Padding(
            padding: const EdgeInsets.only(bottom: SpacingSystem.m),
            child: NivaasCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(SpacingSystem.s),
                            decoration: const BoxDecoration(
                              color: ColorPalette.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.apartment_rounded, color: ColorPalette.primary),
                          ),
                          const SizedBox(width: SpacingSystem.m),
                          Text(
                            wing.name,
                            style: TypographyScale.headingMedium,
                          ),
                        ],
                      ),
                      if (setupState.wings.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: ColorPalette.error),
                          onPressed: () => controller.removeWing(wing.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: SpacingSystem.m),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Floors', style: TypographyScale.caption),
                            const SizedBox(height: 4.0),
                            DropdownButtonFormField<int>(
                              initialValue: wing.totalFloors,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: RadiusSystem.radiusM,
                                  borderSide: BorderSide(color: ColorPalette.outline),
                                ),
                              ),
                              items: List.generate(20, (i) => i + 1)
                                  .map((f) => DropdownMenuItem(value: f, child: Text('$f Floors')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  controller.updateWingConfig(wing.id, val, wing.flatsPerFloor);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SpacingSystem.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Flats / Floor', style: TypographyScale.caption),
                            const SizedBox(height: 4.0),
                            DropdownButtonFormField<int>(
                              initialValue: wing.flatsPerFloor,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: RadiusSystem.radiusM,
                                  borderSide: BorderSide(color: ColorPalette.outline),
                                ),
                              ),
                              items: List.generate(10, (i) => i + 1)
                                  .map((f) => DropdownMenuItem(value: f, child: Text('$f Flats')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  controller.updateWingConfig(wing.id, wing.totalFloors, val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
