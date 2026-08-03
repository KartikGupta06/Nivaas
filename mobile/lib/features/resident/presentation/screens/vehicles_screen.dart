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
import '../../domain/entities/resident_vehicle.dart';
import '../providers/resident_providers.dart';

/// Vehicles Screen for Phase 04.
class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  IconData _getVehicleIcon(String type) {
    switch (type.toUpperCase()) {
      case 'TWO_WHEELER':
        return Icons.two_wheeler;
      case 'ELECTRIC':
        return Icons.electric_car;
      case 'FOUR_WHEELER':
      default:
        return Icons.directions_car;
    }
  }

  void _showAddVehicleModal(BuildContext context, WidgetRef ref) {
    final numberController = TextEditingController();
    final slotController = TextEditingController();
    String vehicleType = 'FOUR_WHEELER';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: EdgeInsets.only(
            left: SpacingSystem.m,
            right: SpacingSystem.m,
            top: SpacingSystem.m,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + SpacingSystem.m,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Register New Vehicle', style: TypographyScale.headingMedium),
              const SizedBox(height: SpacingSystem.m),
              NivaasTextField(
                controller: numberController,
                label: 'Vehicle Number Plate',
                hintText: 'e.g. DL 01 AB 1234',
              ),
              const SizedBox(height: SpacingSystem.s),
              const Text('Vehicle Category', style: TypographyScale.caption),
              const SizedBox(height: SpacingSystem.xs),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('4-Wheeler'),
                      selected: vehicleType == 'FOUR_WHEELER',
                      onSelected: (val) => setStateModal(() => vehicleType = 'FOUR_WHEELER'),
                    ),
                  ),
                  const SizedBox(width: SpacingSystem.xs),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('2-Wheeler'),
                      selected: vehicleType == 'TWO_WHEELER',
                      onSelected: (val) => setStateModal(() => vehicleType = 'TWO_WHEELER'),
                    ),
                  ),
                  const SizedBox(width: SpacingSystem.xs),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Electric EV'),
                      selected: vehicleType == 'ELECTRIC',
                      onSelected: (val) => setStateModal(() => vehicleType = 'ELECTRIC'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SpacingSystem.s),
              NivaasTextField(
                controller: slotController,
                label: 'Parking Slot (Optional)',
                hintText: 'e.g. P1-A402',
              ),
              const SizedBox(height: SpacingSystem.l),
              NivaasButton.primary(
                label: 'Register Vehicle',
                onPressed: () async {
                  if (numberController.text.trim().isEmpty) return;
                  final newVehicle = ResidentVehicle(
                    id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
                    vehicleNumber: numberController.text.trim().toUpperCase(),
                    vehicleType: vehicleType,
                    parkingSlot: slotController.text.trim().isEmpty ? null : slotController.text.trim(),
                    stickerNumber: 'STK-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    status: 'ACTIVE',
                  );
                  final success = await ref.read(vehicleNotifierProvider.notifier).addVehicle(newVehicle);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Vehicle registered successfully!' : 'Failed to add vehicle.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleNotifierProvider);

    return AppScaffold(
      appBar: NivaasAppBar(
        title: 'My Registered Vehicles',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: ColorPalette.primary),
            onPressed: () => _showAddVehicleModal(context, ref),
            tooltip: 'Add Vehicle',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVehicleModal(context, ref),
        backgroundColor: ColorPalette.primary,
        icon: const Icon(Icons.directions_car, color: Colors.white),
        label: const Text('Add Vehicle', style: TextStyle(color: Colors.white)),
      ),
      body: vehicleState.when(
        loading: () => const NivaasLoader(),
        error: (err, _) => Center(
          child: Text('Failed to load vehicles: $err', style: TypographyScale.bodyMedium),
        ),
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return NivaasEmptyState(
              icon: Icons.directions_car_outlined,
              title: 'No Registered Vehicles',
              message: 'Register your vehicles to enable RFID gate access and parking slot tags.',
              actionLabel: 'Add Vehicle',
              onActionPressed: () => _showAddVehicleModal(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(SpacingSystem.m),
            itemCount: vehicles.length,
            separatorBuilder: (_, __) => const SizedBox(height: SpacingSystem.s),
            itemBuilder: (context, index) {
              final v = vehicles[index];
              return NivaasCard(
                padding: const EdgeInsets.all(SpacingSystem.m),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(SpacingSystem.s),
                      decoration: const BoxDecoration(
                        color: ColorPalette.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getVehicleIcon(v.vehicleType), color: ColorPalette.primary, size: 28.0),
                    ),
                    const SizedBox(width: SpacingSystem.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(v.vehicleNumber, style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: v.status == 'ACTIVE' ? Colors.green.shade50 : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  v.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: v.status == 'ACTIVE' ? Colors.green.shade800 : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Type: ${v.vehicleType.replaceAll('_', ' ')}',
                            style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              if (v.parkingSlot != null) ...[
                                const Icon(Icons.local_parking, size: 14, color: ColorPalette.primary),
                                const SizedBox(width: 4),
                                Text('Slot: ${v.parkingSlot}', style: TypographyScale.caption.copyWith(color: ColorPalette.primary)),
                                const SizedBox(width: 12),
                              ],
                              if (v.stickerNumber != null) ...[
                                const Icon(Icons.confirmation_number_outlined, size: 14, color: ColorPalette.textSecondary),
                                const SizedBox(width: 4),
                                Text('Sticker: ${v.stickerNumber}', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
