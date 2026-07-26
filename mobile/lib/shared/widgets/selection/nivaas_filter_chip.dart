import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Selectable Filter Chip.
class NivaasFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const NivaasFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TypographyScale.bodyMedium.copyWith(
          color: isSelected ? ColorPalette.primary : ColorPalette.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: ColorPalette.primaryContainer,
      backgroundColor: ColorPalette.surface,
      checkmarkColor: ColorPalette.primary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? ColorPalette.primary : ColorPalette.outline,
          width: 1.0,
        ),
        borderRadius: RadiusSystem.radiusPill,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingSystem.s,
        vertical: SpacingSystem.xs,
      ),
    );
  }
}
