import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Key-Value Pair Data Row.
class NivaasInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const NivaasInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingSystem.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TypographyScale.bodyMedium.copyWith(
              color: ColorPalette.textSecondary,
            ),
          ),
          Text(
            value,
            style: valueStyle ??
                TypographyScale.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
