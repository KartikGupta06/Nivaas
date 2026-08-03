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

/// Complete House Details Screen conforming to Phase 04 requirements.
class HouseDetailsScreen extends ConsumerWidget {
  const HouseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final houseState = ref.watch(houseNotifierProvider);

    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'House Details',
        showBackButton: true,
      ),
      body: houseState.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(
          child: Text('Failed to load house details: $err', style: TypographyScale.bodyMedium),
        ),
        data: (house) => SingleChildScrollView(
          padding: const EdgeInsets.all(SpacingSystem.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
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
                      child: const Icon(
                        Icons.home,
                        size: 36.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: SpacingSystem.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flat ${house.flatNumber}',
                            style: TypographyScale.headingLarge.copyWith(
                              color: ColorPalette.primary,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${house.wingName} • Floor ${house.floorNumber}',
                            style: TypographyScale.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            house.societyName,
                            style: TypographyScale.caption.copyWith(
                              color: ColorPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              const Text('Unit Specifications', style: TypographyScale.headingSmall),
              const SizedBox(height: SpacingSystem.s),

              NivaasCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    NivaasListTile(
                      leading: const Icon(Icons.apartment, color: ColorPalette.primary),
                      title: 'House Type',
                      subtitle: house.houseType.toUpperCase(),
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.square_foot, color: ColorPalette.primary),
                      title: 'Carpet Area',
                      subtitle: house.areaSqFt != null
                          ? '${house.areaSqFt!.toStringAsFixed(0)} sq. ft.'
                          : 'Not Specified',
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.verified_user_outlined, color: ColorPalette.primary),
                      title: 'Ownership Status',
                      subtitle: house.ownershipStatus,
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.category_outlined, color: ColorPalette.primary),
                      title: 'Maintenance Category',
                      subtitle: house.maintenanceCategory,
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.local_parking_outlined, color: ColorPalette.primary),
                      title: 'Parking Slot',
                      subtitle: house.parkingSlot ?? 'Unassigned (Future Allocation)',
                      trailing: house.parkingSlot != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColorPalette.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('ALLOCATED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ColorPalette.primary)),
                            )
                          : null,
                    ),
                    const Divider(height: 1),
                    NivaasListTile(
                      leading: const Icon(Icons.calendar_today_outlined, color: ColorPalette.primary),
                      title: 'Move-in Date',
                      subtitle: house.moveInDate ?? 'Not specified',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              const Text('Society Location', style: TypographyScale.headingSmall),
              const SizedBox(height: SpacingSystem.s),

              NivaasCard(
                padding: const EdgeInsets.all(SpacingSystem.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: ColorPalette.primary),
                        const SizedBox(width: SpacingSystem.xs),
                        Expanded(
                          child: Text(
                            house.societyName,
                            style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpacingSystem.xs),
                    Text(
                      'Sector 12, Dwarka, New Delhi - 110075',
                      style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
