import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';
import '../buttons/nivaas_button.dart';

/// Reusable Task Completion Success State Display matching DESIGN_SYSTEM.md section 33.
class NivaasSuccessState extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onDone;
  final String doneLabel;

  const NivaasSuccessState({
    super.key,
    required this.title,
    required this.message,
    required this.onDone,
    this.doneLabel = 'Done',
  });

  @override
  State<NivaasSuccessState> createState() => _NivaasSuccessStateState();
}

class _NivaasSuccessStateState extends State<NivaasSuccessState> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingSystem.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(SpacingSystem.l),
              decoration: const BoxDecoration(
                color: ColorPalette.successContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64.0,
                color: ColorPalette.success,
              ),
            ),
            const SizedBox(height: SpacingSystem.l),
            Text(
              widget.title,
              style: TypographyScale.headingLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.s),
            Text(
              widget.message,
              style: TypographyScale.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.xl),
            NivaasButton.primary(
              label: widget.doneLabel,
              onPressed: widget.onDone,
            ),
          ],
        ),
      ),
    );
  }
}
