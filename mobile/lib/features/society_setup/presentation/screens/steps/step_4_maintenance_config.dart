import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';

class Step4MaintenanceConfig extends ConsumerStatefulWidget {
  const Step4MaintenanceConfig({super.key});

  @override
  ConsumerState<Step4MaintenanceConfig> createState() => _Step4MaintenanceConfigState();
}

class _Step4MaintenanceConfigState extends ConsumerState<Step4MaintenanceConfig> {
  late TextEditingController _amountController;
  late TextEditingController _dueDayController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(societySetupControllerProvider);
    _amountController = TextEditingController(text: state.defaultMaintenanceAmount.toStringAsFixed(0));
    _dueDayController = TextEditingController(text: state.maintenanceDueDate.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final amt = double.tryParse(_amountController.text.trim()) ?? 2500.0;
    final day = int.tryParse(_dueDayController.text.trim()) ?? 5;
    ref.read(societySetupControllerProvider.notifier).updateMaintenanceConfig(amt, day);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Maintenance Rule Configuration',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Set default monthly maintenance charges and invoice due dates for your society flats.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        NivaasTextField(
          label: 'Default Monthly Amount (₹)',
          hintText: 'e.g. 2500',
          keyboardType: TextInputType.number,
          controller: _amountController,
          onChanged: (_) => _onChanged(),
        ),
        const NivaasGap.m(),
        NivaasTextField(
          label: 'Monthly Due Date (Day of Month 1-28)',
          hintText: '5',
          keyboardType: TextInputType.number,
          controller: _dueDayController,
          onChanged: (_) => _onChanged(),
        ),
      ],
    );
  }
}
