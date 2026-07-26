import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';
import '../buttons/nivaas_button.dart';

/// Reusable Production-Ready Dialog Component matching DESIGN_SYSTEM.md.
class NivaasDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;

  const NivaasDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
  });

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    IconData? icon = Icons.help_outline,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return NivaasDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          icon: icon,
          iconColor: ColorPalette.primary,
          onConfirm: () => Navigator.pop(dialogContext, true),
          onCancel: () => Navigator.pop(dialogContext, false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: RadiusSystem.radiusL,
      ),
      backgroundColor: ColorPalette.surface,
      insetPadding: const EdgeInsets.all(SpacingSystem.l),
      child: Padding(
        padding: const EdgeInsets.all(SpacingSystem.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 48.0, color: iconColor ?? ColorPalette.primary),
              const SizedBox(height: SpacingSystem.m),
            ],
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
            Row(
              children: [
                if (cancelLabel != null) ...[
                  Expanded(
                    child: NivaasButton.outlined(
                      label: cancelLabel!,
                      onPressed: onCancel ?? () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: SpacingSystem.m),
                ],
                Expanded(
                  child: NivaasButton.primary(
                    label: confirmLabel,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
