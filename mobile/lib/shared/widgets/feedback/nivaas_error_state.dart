import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';
import '../buttons/nivaas_button.dart';

/// Reusable Full-Screen Error State Display with Retry button matching DESIGN_SYSTEM.md section 31.
class NivaasErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const NivaasErrorState({
    super.key,
    this.title = 'Unable to Connect',
    this.message = 'Please check your internet connection and try again.',
    required this.onRetry,
    this.icon = Icons.wifi_off_outlined,
  });

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
                color: ColorPalette.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64.0,
                color: ColorPalette.error,
              ),
            ),
            const SizedBox(height: SpacingSystem.l),
            Text(
              title,
              style: TypographyScale.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.s),
            Text(
              message,
              style: TypographyScale.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.l),
            NivaasButton.primary(
              label: 'Tap to Retry',
              onPressed: onRetry,
              icon: Icons.refresh,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
