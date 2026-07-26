import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';

enum NivaasInfoCardVariant {
  info,
  warning,
  success,
  error,
}

/// Reusable Tinted Status Info Card for messages and warnings.
class NivaasInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final NivaasInfoCardVariant variant;

  const NivaasInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.variant = NivaasInfoCardVariant.info,
  });

  const NivaasInfoCard.info({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.info_outline,
  }) : variant = NivaasInfoCardVariant.info;

  const NivaasInfoCard.warning({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.warning_amber_outlined,
  }) : variant = NivaasInfoCardVariant.warning;

  const NivaasInfoCard.success({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.check_circle_outline,
  }) : variant = NivaasInfoCardVariant.success;

  const NivaasInfoCard.error({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.error_outline,
  }) : variant = NivaasInfoCardVariant.error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getCardColors();

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: RadiusSystem.radiusM,
        border: Border.all(color: colors.border, width: 1.0),
      ),
      padding: const EdgeInsets.all(SpacingSystem.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 24.0, color: colors.iconColor),
            const SizedBox(width: SpacingSystem.m),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: ColorPalette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({Color background, Color border, Color iconColor}) _getCardColors() {
    switch (variant) {
      case NivaasInfoCardVariant.info:
        return (
          background: ColorPalette.primaryContainer,
          border: ColorPalette.primary.withValues(alpha: 0.3),
          iconColor: ColorPalette.primary,
        );
      case NivaasInfoCardVariant.warning:
        return (
          background: ColorPalette.warningContainer,
          border: ColorPalette.warning.withValues(alpha: 0.3),
          iconColor: ColorPalette.warning,
        );
      case NivaasInfoCardVariant.success:
        return (
          background: ColorPalette.successContainer,
          border: ColorPalette.success.withValues(alpha: 0.3),
          iconColor: ColorPalette.success,
        );
      case NivaasInfoCardVariant.error:
        return (
          background: ColorPalette.errorContainer,
          border: ColorPalette.error.withValues(alpha: 0.3),
          iconColor: ColorPalette.error,
        );
    }
  }
}
