import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/maintenance_config.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_dropdown.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';

class Step5MaintenanceConfig extends ConsumerStatefulWidget {
  const Step5MaintenanceConfig({super.key});

  @override
  ConsumerState<Step5MaintenanceConfig> createState() => _Step5MaintenanceConfigState();
}

class _Step5MaintenanceConfigState extends ConsumerState<Step5MaintenanceConfig> {
  late TextEditingController _amountController;
  late TextEditingController _dueDayController;
  late TextEditingController _lateFeeController;
  late TextEditingController _gracePeriodController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(societySetupControllerProvider).maintenanceConfig;
    _amountController = TextEditingController(text: config.defaultAmount.toStringAsFixed(0));
    _dueDayController = TextEditingController(text: config.dueDateDay.toString());
    _lateFeeController = TextEditingController(text: config.lateFeeAmount.toStringAsFixed(0));
    _gracePeriodController = TextEditingController(text: config.gracePeriodDays.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dueDayController.dispose();
    _lateFeeController.dispose();
    _gracePeriodController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final state = ref.read(societySetupControllerProvider);
    final amt = double.tryParse(_amountController.text.trim()) ?? 2500.0;
    final day = int.tryParse(_dueDayController.text.trim()) ?? 5;
    final fee = double.tryParse(_lateFeeController.text.trim()) ?? 0.0;
    final grace = int.tryParse(_gracePeriodController.text.trim()) ?? 0;

    ref.read(societySetupControllerProvider.notifier).updateMaintenanceConfig(
          state.maintenanceConfig.copyWith(
            defaultAmount: amt,
            dueDateDay: day,
            lateFeeAmount: fee,
            gracePeriodDays: grace,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(societySetupControllerProvider);
    final controller = ref.watch(societySetupControllerProvider.notifier);
    final config = setupState.maintenanceConfig;

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Maintenance Rule Configuration',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Configure society maintenance rule type, default monthly charges, and due dates.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        NivaasDropdown<MaintenanceRuleType>(
          label: 'Maintenance Rule Strategy',
          value: config.ruleType,
          items: MaintenanceRuleType.values
              .map((type) => NivaasDropdownItem(value: type, label: type.displayName))
              .toList(),
          onChanged: (val) {
            controller.updateMaintenanceConfig(config.copyWith(ruleType: val));
          },
        ),
        const NivaasGap.m(),
        NivaasTextField(
          label: 'Default Monthly Amount (₹) *',
          hintText: 'e.g. 2500',
          keyboardType: TextInputType.number,
          controller: _amountController,
          onChanged: (_) => _onChanged(),
        ),
        const NivaasGap.m(),
        NivaasTextField(
          label: 'Monthly Due Date (Day of Month 1-28) *',
          hintText: '5',
          keyboardType: TextInputType.number,
          controller: _dueDayController,
          onChanged: (_) => _onChanged(),
        ),
        const NivaasGap.m(),
        Row(
          children: [
            Expanded(
              child: NivaasTextField(
                label: 'Late Fee Amount (Future ₹)',
                hintText: 'e.g. 200',
                keyboardType: TextInputType.number,
                controller: _lateFeeController,
                onChanged: (_) => _onChanged(),
              ),
            ),
            const SizedBox(width: SpacingSystem.m),
            Expanded(
              child: NivaasTextField(
                label: 'Grace Period (Days)',
                hintText: 'e.g. 5',
                keyboardType: TextInputType.number,
                controller: _gracePeriodController,
                onChanged: (_) => _onChanged(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
