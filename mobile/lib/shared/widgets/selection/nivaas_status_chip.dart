import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

enum NivaasStatusType {
  approved,
  pending,
  denied,
  inside,
  exited,
  overdue,
  custom,
}

/// Premium Color-Coded Full Pill Status Chip Component.
class NivaasStatusChip extends StatelessWidget {
  final String label;
  final NivaasStatusType type;
  final Color? customBackground;
  final Color? customText;

  const NivaasStatusChip({
    super.key,
    required this.label,
    this.type = NivaasStatusType.custom,
    this.customBackground,
    this.customText,
  });

  const NivaasStatusChip.approved({super.key, this.label = 'APPROVED'})
      : type = NivaasStatusType.approved,
        customBackground = null,
        customText = null;

  const NivaasStatusChip.pending({super.key, this.label = 'PENDING'})
      : type = NivaasStatusType.pending,
        customBackground = null,
        customText = null;

  const NivaasStatusChip.denied({super.key, this.label = 'DENIED'})
      : type = NivaasStatusType.denied,
        customBackground = null,
        customText = null;

  const NivaasStatusChip.inside({super.key, this.label = 'INSIDE'})
      : type = NivaasStatusType.inside,
        customBackground = null,
        customText = null;

  const NivaasStatusChip.exited({super.key, this.label = 'EXITED'})
      : type = NivaasStatusType.exited,
        customBackground = null,
        customText = null;

  const NivaasStatusChip.overdue({super.key, this.label = 'OVERDUE'})
      : type = NivaasStatusType.overdue,
        customBackground = null,
        customText = null;

  @override
  Widget build(BuildContext context) {
    final colors = _getChipColors();

    return Semantics(
      label: 'Status $label',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: RadiusSystem.radiusPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: colors.textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: SpacingSystem.xs),
            Text(
              label.toUpperCase(),
              style: TypographyScale.caption.copyWith(
                color: colors.textColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({Color background, Color textColor}) _getChipColors() {
    switch (type) {
      case NivaasStatusType.approved:
      case NivaasStatusType.inside:
        return (
          background: ColorPalette.successContainer,
          textColor: ColorPalette.success,
        );

      case NivaasStatusType.pending:
        return (
          background: ColorPalette.warningContainer,
          textColor: ColorPalette.warning,
        );

      case NivaasStatusType.denied:
      case NivaasStatusType.overdue:
        return (
          background: ColorPalette.errorContainer,
          textColor: ColorPalette.error,
        );

      case NivaasStatusType.exited:
        return (
          background: ColorPalette.surfaceSubtle,
          textColor: ColorPalette.textSecondary,
        );

      case NivaasStatusType.custom:
        return (
          background: customBackground ?? ColorPalette.infoContainer,
          textColor: customText ?? ColorPalette.info,
        );
    }
  }
}
