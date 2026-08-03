import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../../shared/widgets/navigation/nivaas_list_tile.dart';
import '../providers/resident_providers.dart';

/// Society Information Screen for Phase 04.
class SocietyInfoScreen extends ConsumerWidget {
  const SocietyInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final societyAsync = ref.watch(societyInfoProvider);

    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Society Information',
        showBackButton: true,
      ),
      body: societyAsync.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(
          child: Text('Failed to load society info: $err', style: TypographyScale.bodyMedium),
        ),
        data: (society) => SingleChildScrollView(
          padding: const EdgeInsets.all(SpacingSystem.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Header Card
              NivaasCard(
                padding: const EdgeInsets.all(SpacingSystem.l),
                backgroundColor: ColorPalette.primaryContainer,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(SpacingSystem.m),
                      decoration: const BoxDecoration(
                        color: ColorPalette.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.business, size: 36.0, color: Colors.white),
                    ),
                    const SizedBox(width: SpacingSystem.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(society.name, style: TypographyScale.headingSmall.copyWith(color: ColorPalette.primary)),
                          const SizedBox(height: 4.0),
                          Text('Resident Welfare Association (RWA)', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              const Text('Office & Contact Directory', style: TypographyScale.headingSmall),
              const SizedBox(height: SpacingSystem.s),

              NivaasCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    NivaasListTile(
                      leading: const Icon(Icons.location_on_outlined, color: ColorPalette.primary),
                      title: 'Society Address',
                      subtitle: society.address,
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.phone_outlined, color: ColorPalette.primary),
                      title: 'Office Contact Number',
                      subtitle: society.officeContact,
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.access_time_outlined, color: ColorPalette.primary),
                      title: 'Office Timings',
                      subtitle: society.officeTiming,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              const Text('RWA Committee Members', style: TypographyScale.headingSmall),
              const SizedBox(height: SpacingSystem.s),

              NivaasCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: society.committeeMembers.map((member) {
                    return Column(
                      children: [
                        NivaasListTile(
                          leading: const Icon(Icons.person_pin_outlined, color: ColorPalette.primary),
                          title: member,
                          subtitle: 'Elected Committee Member',
                        ),
                        if (member != society.committeeMembers.last) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
