import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/color_palette.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/cards/nivaas_card.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';
import 'package:nivaas_mobile/shared/widgets/selection/nivaas_switch.dart';

class Step3FloorConfig extends ConsumerWidget {
  const Step3FloorConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(societySetupControllerProvider);
    final controller = ref.watch(societySetupControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Floor & Structure Strategy',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Configure basement floors, ground floor, terrace access, and floor numbering strategies.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        ...setupState.wings.map((wing) {
          return Padding(
            padding: const EdgeInsets.only(bottom: SpacingSystem.m),
            child: NivaasCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.layers_rounded, color: ColorPalette.primary),
                      const SizedBox(width: SpacingSystem.s),
                      Text(
                        '${wing.name} Structure',
                        style: TypographyScale.headingMedium,
                      ),
                    ],
                  ),
                  const Divider(height: 24.0, color: ColorPalette.outline),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Basement Floors (Future)', style: TypographyScale.headingSmall),
                          Text('Configure parking/utility basements', style: TypographyScale.caption),
                        ],
                      ),
                      DropdownButton<int>(
                        value: wing.basementFloors,
                        items: List.generate(4, (i) => i)
                            .map((b) => DropdownMenuItem(value: b, child: Text(b == 0 ? 'None' : 'B$b ($b Basement)')))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.updateWingConfig(
                              wing.id,
                              wing.totalFloors,
                              wing.flatsPerFloor,
                              basementFloors: val,
                              hasTerrace: wing.hasTerrace,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingSystem.m),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Terrace Access (Future)', style: TypographyScale.headingSmall),
                          Text('Include terrace penthouse/roof floor', style: TypographyScale.caption),
                        ],
                      ),
                      NivaasSwitch(
                        value: wing.hasTerrace,
                        onChanged: (val) {
                          controller.updateWingConfig(
                            wing.id,
                            wing.totalFloors,
                            wing.flatsPerFloor,
                            basementFloors: wing.basementFloors,
                            hasTerrace: val,
                          );
                        },
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
