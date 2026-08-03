import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/cards/nivaas_clickable_card.dart';
import '../../../../shared/widgets/inputs/nivaas_text_field.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../providers/visitor_providers.dart';

/// Ultra-Fast Emergency Entry Screen (Ambulance, Police, Fire Brigade, SOS).
class EmergencyEntryScreen extends ConsumerStatefulWidget {
  const EmergencyEntryScreen({super.key});

  @override
  ConsumerState<EmergencyEntryScreen> createState() => _EmergencyEntryScreenState();
}

class _EmergencyEntryScreenState extends ConsumerState<EmergencyEntryScreen> {
  final _flatController = TextEditingController(text: 'ALL');
  final _notesController = TextEditingController();
  String _selectedEmergency = 'AMBULANCE';
  bool _isSubmitting = false;

  final List<({String type, String label, IconData icon, Color color})> _types = [
    (type: 'AMBULANCE', label: 'Ambulance 102', icon: Icons.medical_services, color: ColorPalette.error),
    (type: 'POLICE', label: 'Police 112', icon: Icons.local_police, color: Colors.indigo),
    (type: 'FIRE', label: 'Fire Brigade 101', icon: Icons.local_fire_department, color: Colors.deepOrange),
    (type: 'SOCIETY_SOS', label: 'Society Emergency', icon: Icons.warning_amber, color: Colors.red.shade800),
  ];

  Future<void> _submitEmergencyEntry() async {
    setState(() => _isSubmitting = true);

    final log = await ref.read(visitorNotifierProvider.notifier).registerEmergency(
      emergencyType: _selectedEmergency,
      flatNumber: _flatController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await ref.read(gateNotifierProvider.notifier).loadGateSummary();

    setState(() => _isSubmitting = false);

    if (mounted && log != null) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: ColorPalette.errorContainer,
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: ColorPalette.error, size: 32),
              SizedBox(width: 8),
              Text('EMERGENCY GATE OVERRIDE', style: TextStyle(color: ColorPalette.error, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Emergency Type: ${log.visitorName}', style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              Text('Gate Pass: ${log.passCode}', style: TypographyScale.bodyMedium),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpacingSystem.m),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorPalette.error),
                ),
                child: const Column(
                  children: [
                    Text('GATE BOOM BARRIER OPENED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorPalette.error)),
                    SizedBox(height: 4),
                    Text('All society admins & residents notified.', style: TextStyle(fontSize: 11, color: ColorPalette.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            NivaasButton.danger(
              label: 'Acknowledge & Close',
              onPressed: () {
                Navigator.pop(ctx);
                context.pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Emergency Override Entry',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingSystem.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(SpacingSystem.m),
              decoration: BoxDecoration(
                color: ColorPalette.errorContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorPalette.error, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: ColorPalette.error, size: 32),
                  const SizedBox(width: SpacingSystem.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1-Tap Emergency Gate Override', style: TypographyScale.bodyLarge.copyWith(color: ColorPalette.error, fontWeight: FontWeight.bold)),
                        Text('Instant barrier open & emergency broadcast', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingSystem.l),

            const Text('Select Emergency Vehicle / Force', style: TypographyScale.headingSmall),
            const SizedBox(height: SpacingSystem.s),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _types.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: SpacingSystem.s,
                crossAxisSpacing: SpacingSystem.s,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final t = _types[index];
                final isSelected = _selectedEmergency == t.type;

                return NivaasClickableCard(
                  onTap: () => setState(() => _selectedEmergency = t.type),
                  padding: const EdgeInsets.all(SpacingSystem.s),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? t.color.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(color: t.color, width: 2) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t.icon, color: t.color, size: 32.0),
                        const SizedBox(height: 4),
                        Text(
                          t.label,
                          style: TypographyScale.bodyMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? t.color : ColorPalette.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: SpacingSystem.l),

            NivaasCard(
              padding: const EdgeInsets.all(SpacingSystem.m),
              child: Column(
                children: [
                  NivaasTextField(
                    controller: _flatController,
                    label: 'Target Location / Flat',
                    hintText: 'e.g. Flat A-402 or Wing B',
                  ),
                  const SizedBox(height: SpacingSystem.s),
                  NivaasTextField(
                    controller: _notesController,
                    label: 'Emergency Brief (Optional)',
                    hintText: 'e.g. Medical distress on 4th floor',
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingSystem.l),

            NivaasButton.danger(
              label: 'TRIGGER EMERGENCY GATE OPEN',
              icon: Icons.emergency,
              isLoading: _isSubmitting,
              onPressed: _submitEmergencyEntry,
            ),
          ],
        ),
      ),
    );
  }
}
