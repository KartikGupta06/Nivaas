import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';
import '../buttons/nivaas_button.dart';

/// Premium Dialog Component matching Apple & Notion dialog aesthetics (24dp radius).
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
    IconData? icon = Icons.help_outline_rounded,
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
              Container(
                padding: const EdgeInsets.all(SpacingSystem.m),
                decoration: BoxDecoration(
                  color: (iconColor ?? ColorPalette.primary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32.0, color: iconColor ?? ColorPalette.primary),
              ),
              const SizedBox(height: SpacingSystem.m),
            ],
            Text(
              title,
              style: TypographyScale.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.xs),
            Text(
              message,
              style: TypographyScale.bodyMedium.copyWith(color: ColorPalette.textSecondary),
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
