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
import '../../../../shared/widgets/selection/nivaas_status_chip.dart';
import '../providers/visitor_providers.dart';

/// Visitor History & Search Timeline Screen.
class VisitorHistoryScreen extends ConsumerStatefulWidget {
  final String? initialStatus;

  const VisitorHistoryScreen({super.key, this.initialStatus});

  @override
  ConsumerState<VisitorHistoryScreen> createState() => _VisitorHistoryScreenState();
}

class _VisitorHistoryScreenState extends ConsumerState<VisitorHistoryScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus != null && widget.initialStatus!.isNotEmpty) {
      _selectedStatus = widget.initialStatus!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(historyNotifierProvider.notifier).setStatusFilter(_selectedStatus);
      });
    }
  }

  NivaasStatusType _mapStatusType(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return NivaasStatusType.approved;
      case 'CHECKED_IN':
        return NivaasStatusType.inside;
      case 'CHECKED_OUT':
      case 'EXITED':
        return NivaasStatusType.exited;
      case 'REJECTED':
      case 'DENIED':
        return NivaasStatusType.denied;
      case 'WAITING_APPROVAL':
      case 'PENDING':
      default:
        return NivaasStatusType.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyNotifierProvider);

    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Visitor History & Audit',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search Bar & Filter Chips Header
          Padding(
            padding: const EdgeInsets.all(SpacingSystem.m),
            child: Column(
              children: [
                NivaasTextField(
                  controller: _searchController,
                  label: 'Search History',
                  hintText: 'Search by Name, Phone, Flat, Vehicle, or Pass Code',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (val) {
                    ref.read(historyNotifierProvider.notifier).setSearchQuery(val.trim());
                  },
                ),
                const SizedBox(height: SpacingSystem.s),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All Logs',
                        isSelected: _selectedStatus == 'ALL',
                        onTap: () {
                          setState(() => _selectedStatus = 'ALL');
                          ref.read(historyNotifierProvider.notifier).setStatusFilter('ALL');
                        },
                      ),
                      const SizedBox(width: SpacingSystem.xs),
                      _FilterChip(
                        label: 'Inside Now',
                        isSelected: _selectedStatus == 'CHECKED_IN',
                        onTap: () {
                          setState(() => _selectedStatus = 'CHECKED_IN');
                          ref.read(historyNotifierProvider.notifier).setStatusFilter('CHECKED_IN');
                        },
                      ),
                      const SizedBox(width: SpacingSystem.xs),
                      _FilterChip(
                        label: 'Pending Approval',
                        isSelected: _selectedStatus == 'WAITING_APPROVAL',
                        onTap: () {
                          setState(() => _selectedStatus = 'WAITING_APPROVAL');
                          ref.read(historyNotifierProvider.notifier).setStatusFilter('WAITING_APPROVAL');
                        },
                      ),
                      const SizedBox(width: SpacingSystem.xs),
                      _FilterChip(
                        label: 'Exited',
                        isSelected: _selectedStatus == 'CHECKED_OUT',
                        onTap: () {
                          setState(() => _selectedStatus = 'CHECKED_OUT');
                          ref.read(historyNotifierProvider.notifier).setStatusFilter('CHECKED_OUT');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Timeline Logs List
          Expanded(
            child: historyState.when(
              loading: () => const NivaasLoader(),
              error: (err, _) => Center(child: Text('Failed to load history: $err', style: TypographyScale.bodyMedium)),
              data: (logs) {
                if (logs.isEmpty) {
                  return const NivaasEmptyState(
                    icon: Icons.history_toggle_off,
                    title: 'No Visitor Logs Found',
                    message: 'No visitor entries match your search criteria.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: SpacingSystem.m, vertical: SpacingSystem.xs),
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: SpacingSystem.s),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final isInside = log.status == 'CHECKED_IN';

                    return NivaasCard(
                      padding: const EdgeInsets.all(SpacingSystem.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              NivaasAvatar(name: log.visitorName, radius: 22.0),
                              const SizedBox(width: SpacingSystem.m),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(log.visitorName, style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                    Text('${log.wingName} • Flat ${log.flatNumber}', style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.primary, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              NivaasStatusChip(
                                label: log.status.replaceAll('_', ' '),
                                type: _mapStatusType(log.status),
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingSystem.s),
                          const Divider(height: 1),
                          const SizedBox(height: SpacingSystem.s),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Purpose: ${log.purpose}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                                    Text('Check-in: ${log.checkInTime}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                                    if (log.checkOutTime != null)
                                      Text('Check-out: ${log.checkOutTime} (${log.durationMinutes ?? 0} mins)', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                                    if (log.vehicleNumber != null)
                                      Text('Vehicle: ${log.vehicleNumber}', style: TypographyScale.caption.copyWith(color: ColorPalette.primary)),
                                  ],
                                ),
                              ),
                              if (isInside)
                                NivaasButton.secondary(
                                  label: 'CHECK OUT',
                                  icon: Icons.logout,
                                  isFullWidth: false,
                                  onPressed: () async {
                                    final success = await ref.read(gateNotifierProvider.notifier).checkOutVisitor(log.id);
                                    await ref.read(historyNotifierProvider.notifier).loadHistory();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(success ? 'Visitor ${log.visitorName} checked out!' : 'Failed to check out.'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: ColorPalette.primaryContainer,
      onSelected: (_) => onTap(),
    );
  }
}
