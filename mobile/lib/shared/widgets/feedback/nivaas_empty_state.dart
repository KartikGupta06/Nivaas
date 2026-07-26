import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';
import '../buttons/nivaas_button.dart';

/// Reusable Empty State Display matching DESIGN_SYSTEM.md section 29.
class NivaasEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const NivaasEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onActionPressed,
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
                color: ColorPalette.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64.0,
                color: ColorPalette.primary,
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
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: SpacingSystem.l),
              NivaasButton.primary(
                label: actionLabel!,
                onPressed: onActionPressed,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
