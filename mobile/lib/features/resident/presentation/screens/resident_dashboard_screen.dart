import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/routes/route_names.dart';
import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/cards/nivaas_clickable_card.dart';
import '../../../../shared/widgets/feedback/nivaas_empty_state.dart';
import '../../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../../shared/widgets/navigation/nivaas_avatar.dart';
import '../providers/resident_providers.dart';

/// Premium Resident Dashboard Workspace Screen conforming to Phase 04.
class ResidentDashboardScreen extends ConsumerWidget {
  const ResidentDashboardScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _showPlaceholderNotice(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title placeholder — Coming soon in future module!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final houseState = ref.watch(houseNotifierProvider);
    final familyState = ref.watch(familyNotifierProvider);
    final vehicleState = ref.watch(vehicleNotifierProvider);
    final contactsState = ref.watch(emergencyContactsProvider);

    return AppScaffold(
      appBar: NivaasAppBar(
        title: 'Nivaas Workspace',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: ColorPalette.textPrimary),
            onPressed: () => context.push(RouteNames.residentProfile),
            tooltip: 'View Profile',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: ColorPalette.textPrimary),
            onPressed: () => context.push(RouteNames.societyInfo),
            tooltip: 'Society Details',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileNotifierProvider.notifier).loadProfile();
          await ref.read(houseNotifierProvider.notifier).loadHouseDetail();
          await ref.read(familyNotifierProvider.notifier).loadFamilyMembers();
          await ref.read(vehicleNotifierProvider.notifier).loadVehicles();
          ref.invalidate(emergencyContactsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SpacingSystem.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Resident Profile Header
              profileState.when(
                loading: () => const NivaasLoader(),
                error: (err, _) => Text('Error: $err', style: TypographyScale.bodyMedium),
                data: (profile) => houseState.when(
                  loading: () => const NivaasLoader(),
                  error: (err, _) => Text('Error: $err', style: TypographyScale.bodyMedium),
                  data: (house) => NivaasClickableCard(
                    onTap: () => context.push(RouteNames.residentProfile),
                    padding: const EdgeInsets.all(SpacingSystem.m),
                    child: Row(
                      children: [
                        NivaasAvatar(
                          name: profile.fullName,
                          imageUrl: profile.avatarUrl,
                          radius: 28.0,
                        ),
                        const SizedBox(width: SpacingSystem.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, ${profile.fullName.split(' ').first}!',
                                style: TypographyScale.headingSmall.copyWith(
                                  color: ColorPalette.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${house.wingName} • Floor ${house.floorNumber} • Flat ${house.flatNumber}',
                                style: TypographyScale.bodyMedium.copyWith(
                                  color: ColorPalette.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                house.societyName,
                                style: TypographyScale.caption.copyWith(
                                  color: ColorPalette.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: ColorPalette.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              // Overview Cards Grid
              const Text(
                'My Workspace Overview',
                style: TypographyScale.headingSmall,
              ),
              const SizedBox(height: SpacingSystem.s),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: SpacingSystem.s,
                crossAxisSpacing: SpacingSystem.s,
                childAspectRatio: 1.5,
                children: [
                  _OverviewItemCard(
                    title: 'House Details',
                    subtitle: houseState.maybeWhen(
                      data: (h) => 'Flat ${h.flatNumber} (${h.houseType})',
                      orElse: () => 'View Specs',
                    ),
                    icon: Icons.home_outlined,
                    color: ColorPalette.primary,
                    onTap: () => context.push(RouteNames.houseDetails),
                  ),
                  _OverviewItemCard(
                    title: 'Family Members',
                    subtitle: familyState.maybeWhen(
                      data: (list) => '${list.length} Members',
                      orElse: () => '0 Members',
                    ),
                    icon: Icons.people_outline,
                    color: Colors.deepOrange,
                    onTap: () => context.push(RouteNames.familyMembers),
                  ),
                  _OverviewItemCard(
                    title: 'Vehicles',
                    subtitle: vehicleState.maybeWhen(
                      data: (list) => '${list.length} Vehicles',
                      orElse: () => '0 Vehicles',
                    ),
                    icon: Icons.directions_car_outlined,
                    color: Colors.teal,
                    onTap: () => context.push(RouteNames.residentVehicles),
                  ),
                  _OverviewItemCard(
                    title: 'Emergency Contacts',
                    subtitle: contactsState.maybeWhen(
                      data: (list) => '${list.length} Contacts',
                      orElse: () => '7 Contacts',
                    ),
                    icon: Icons.phone_in_talk_outlined,
                    color: ColorPalette.error,
                    onTap: () => context.push(RouteNames.emergencyContacts),
                  ),
                ],
              ),

              const SizedBox(height: SpacingSystem.l),

              // Quick Actions Shortcuts
              const Text(
                'Quick Shortcuts',
                style: TypographyScale.headingSmall,
              ),
              const SizedBox(height: SpacingSystem.s),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _QuickActionTile(
                      label: 'Visitors',
                      icon: Icons.badge_outlined,
                      onTap: () => _showPlaceholderNotice(context, 'Visitors'),
                    ),
                    const SizedBox(width: SpacingSystem.xs),
                    _QuickActionTile(
                      label: 'Complaints',
                      icon: Icons.report_problem_outlined,
                      onTap: () => _showPlaceholderNotice(context, 'Complaints'),
                    ),
                    const SizedBox(width: SpacingSystem.xs),
                    _QuickActionTile(
                      label: 'Bills',
                      icon: Icons.receipt_long_outlined,
                      onTap: () => _showPlaceholderNotice(context, 'Bills'),
                    ),
                    const SizedBox(width: SpacingSystem.xs),
                    _QuickActionTile(
                      label: 'Payments',
                      icon: Icons.payment_outlined,
                      onTap: () => _showPlaceholderNotice(context, 'Payments'),
                    ),
                    const SizedBox(width: SpacingSystem.xs),
                    _QuickActionTile(
                      label: 'Documents',
                      icon: Icons.folder_outlined,
                      onTap: () => _showPlaceholderNotice(context, 'Documents'),
                    ),
                    const SizedBox(width: SpacingSystem.xs),
                    _QuickActionTile(
                      label: 'Parking',
                      icon: Icons.local_parking_outlined,
                      onTap: () => _showPlaceholderNotice(context, 'Parking'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              // Upcoming Due Items Section (Placeholder & Empty State)
              const Text(
                'Upcoming Due Items',
                style: TypographyScale.headingSmall,
              ),
              const SizedBox(height: SpacingSystem.s),
              const NivaasCard(
                padding: EdgeInsets.all(SpacingSystem.m),
                child: NivaasEmptyState(
                  icon: Icons.task_alt,
                  title: 'No Pending Payments or Dues',
                  message: 'Your flat maintenance payments and society dues are all up to date!',
                ),
              ),

              const SizedBox(height: SpacingSystem.l),

              // Recent Activity Section (Placeholder & Empty State)
              const Text(
                'Recent Activity',
                style: TypographyScale.headingSmall,
              ),
              const SizedBox(height: SpacingSystem.s),
              const NivaasCard(
                padding: EdgeInsets.all(SpacingSystem.m),
                child: NivaasEmptyState(
                  icon: Icons.history,
                  title: 'No Recent Activity',
                  message: 'Gate visitor check-ins and society notifications will appear here.',
                ),
              ),

              const SizedBox(height: SpacingSystem.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OverviewItemCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NivaasClickableCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SpacingSystem.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(SpacingSystem.xs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22.0),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward, size: 16.0, color: ColorPalette.textMuted),
            ],
          ),
          const SizedBox(height: SpacingSystem.xs),
          Text(
            title,
            style: TypographyScale.caption.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: TypographyScale.caption.copyWith(
              color: ColorPalette.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: NivaasClickableCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(vertical: SpacingSystem.s, horizontal: SpacingSystem.xs),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(SpacingSystem.xs),
              decoration: const BoxDecoration(
                color: ColorPalette.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ColorPalette.primary, size: 24.0),
            ),
            const SizedBox(height: SpacingSystem.xs),
            Text(
              label,
              style: TypographyScale.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
