import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

enum NivaasInfoCardVariant {
  info,
  warning,
  success,
  error,
}

/// Premium Tinted Status Info Card Component matching Apple & Linear style.
class NivaasInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final NivaasInfoCardVariant variant;
  final IconData? icon;

  const NivaasInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.variant = NivaasInfoCardVariant.info,
    this.icon,
  });

  const NivaasInfoCard.info({
    super.key,
    required this.title,
    this.subtitle,
  })  : variant = NivaasInfoCardVariant.info,
        icon = Icons.info_outline_rounded;

  const NivaasInfoCard.warning({
    super.key,
    required this.title,
    this.subtitle,
  })  : variant = NivaasInfoCardVariant.warning,
        icon = Icons.warning_amber_rounded;

  const NivaasInfoCard.success({
    super.key,
    required this.title,
    this.subtitle,
  })  : variant = NivaasInfoCardVariant.success,
        icon = Icons.check_circle_outline_rounded;

  const NivaasInfoCard.error({
    super.key,
    required this.title,
    this.subtitle,
  })  : variant = NivaasInfoCardVariant.error,
        icon = Icons.error_outline_rounded;

  @override
  Widget build(BuildContext context) {
    final style = _getVariantStyle();

    return Container(
      padding: const EdgeInsets.all(SpacingSystem.m),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: RadiusSystem.radiusM,
        border: Border.all(color: style.borderColor, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? style.icon, color: style.iconColor, size: 22.0),
          const SizedBox(width: SpacingSystem.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TypographyScale.headingSmall.copyWith(
                    color: style.textColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: SpacingSystem.xs),
                  Text(
                    subtitle!,
                    style: TypographyScale.bodyMedium.copyWith(
                      color: style.textColor.withValues(alpha: 0.85),
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

  ({
    Color background,
    Color borderColor,
    Color textColor,
    Color iconColor,
    IconData icon,
  }) _getVariantStyle() {
    switch (variant) {
      case NivaasInfoCardVariant.info:
        return (
          background: ColorPalette.infoContainer,
          borderColor: ColorPalette.info.withValues(alpha: 0.2),
          textColor: ColorPalette.info,
          iconColor: ColorPalette.info,
          icon: Icons.info_outline_rounded,
        );
      case NivaasInfoCardVariant.warning:
        return (
          background: ColorPalette.warningContainer,
          borderColor: ColorPalette.warning.withValues(alpha: 0.2),
          textColor: ColorPalette.warning,
          iconColor: ColorPalette.warning,
          icon: Icons.warning_amber_rounded,
        );
      case NivaasInfoCardVariant.success:
        return (
          background: ColorPalette.successContainer,
          borderColor: ColorPalette.success.withValues(alpha: 0.2),
          textColor: ColorPalette.success,
          iconColor: ColorPalette.success,
          icon: Icons.check_circle_outline_rounded,
        );
      case NivaasInfoCardVariant.error:
        return (
          background: ColorPalette.errorContainer,
          borderColor: ColorPalette.error.withValues(alpha: 0.2),
          textColor: ColorPalette.error,
          iconColor: ColorPalette.error,
          icon: Icons.error_outline_rounded,
        );
    }
  }
}
