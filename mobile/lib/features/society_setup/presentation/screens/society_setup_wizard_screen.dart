import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/routes/route_names.dart';
import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../app/providers/app_config_provider.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';

import '../providers/society_setup_controller.dart';
import 'steps/step_1_society_profile.dart';
import 'steps/step_2_wing_config.dart';
import 'steps/step_3_house_layout_engine.dart';
import 'steps/step_4_maintenance_config.dart';
import 'steps/step_5_owner_assignment.dart';
import 'steps/step_6_review_complete.dart';

/// Multi-Step Onboarding Wizard Screen for Society Setup.
class SocietySetupWizardScreen extends ConsumerWidget {
  const SocietySetupWizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(societySetupControllerProvider);
    final controller = ref.watch(societySetupControllerProvider.notifier);
    final appConfig = ref.watch(appConfigProvider);

    final steps = [
      const Step1SocietyProfile(),
      const Step2WingConfig(),
      const Step3HouseLayoutEngine(),
      const Step4MaintenanceConfig(),
      const Step5OwnerAssignment(),
      const Step6ReviewComplete(),
    ];

    final stepTitles = [
      'Profile',
      'Wings',
      'Flats Engine',
      'Maintenance',
      'Owners',
      'Review',
    ];

    return Scaffold(
      appBar: NivaasAppBar(
        title: 'Society Setup • Step ${setupState.currentStep + 1} of ${steps.length}',
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.go(RouteNames.adminHome),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (setupState.currentStep + 1) / steps.length,
              backgroundColor: ColorPalette.surfaceSubtle,
              color: ColorPalette.primaryAccent,
              minHeight: 4.0,
            ),

            // Step Indicator Header
            Container(
              color: ColorPalette.surface,
              padding: const EdgeInsets.symmetric(horizontal: SpacingSystem.m, vertical: SpacingSystem.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(steps.length, (index) {
                  final isSelected = setupState.currentStep == index;
                  final isDone = setupState.currentStep > index;

                  return InkWell(
                    onTap: () => controller.setStep(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12.0,
                          backgroundColor: isDone
                              ? ColorPalette.success
                              : (isSelected ? ColorPalette.primaryAccent : ColorPalette.outline),
                          child: isDone
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TypographyScale.caption.copyWith(
                                    color: isSelected ? Colors.white : ColorPalette.textSecondary,
                                    fontSize: 10.0,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          stepTitles[index],
                          style: TypographyScale.caption.copyWith(
                            fontSize: 10.0,
                            color: isSelected ? ColorPalette.primary : ColorPalette.textMuted,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const Divider(height: 1.0, color: ColorPalette.outline),

            // Wizard Step Page Content
            Expanded(
              child: IndexedStack(
                index: setupState.currentStep,
                children: steps,
              ),
            ),

            // Dev Mode Quick Generator Bar
            if (appConfig.isDevelopment)
              Container(
                color: ColorPalette.warningContainer,
                padding: const EdgeInsets.symmetric(horizontal: SpacingSystem.m, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🛠️ DEV MODE',
                      style: TypographyScale.caption.copyWith(
                        color: ColorPalette.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.generateDemoSociety(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ColorPalette.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: ColorPalette.warning),
                        ),
                        child: Text(
                          'Generate Demo Society Data',
                          style: TypographyScale.caption.copyWith(
                            color: ColorPalette.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Wizard Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.all(SpacingSystem.m),
              decoration: const BoxDecoration(
                color: ColorPalette.surface,
                border: Border(top: BorderSide(color: ColorPalette.outline, width: 1.0)),
              ),
              child: Row(
                children: [
                  if (setupState.currentStep > 0) ...[
                    Expanded(
                      child: NivaasButton.outlined(
                        label: 'Previous',
                        onPressed: () => controller.setStep(setupState.currentStep - 1),
                      ),
                    ),
                    const SizedBox(width: SpacingSystem.m),
                  ],
                  Expanded(
                    child: NivaasButton.primary(
                      label: setupState.currentStep == steps.length - 1 ? 'Submit & Finalize' : 'Continue',
                      isLoading: setupState.isSubmitting,
                      onPressed: () async {
                        if (setupState.currentStep < steps.length - 1) {
                          controller.setStep(setupState.currentStep + 1);
                        } else {
                          final success = await controller.submitFinalSetup();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Society Setup Completed Successfully!')),
                            );
                            context.go(RouteNames.adminHome);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
