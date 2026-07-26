import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Radio Widget enforcing 48dp minimum touch container.
class NivaasRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String? label;

  const NivaasRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    // Ignore deprecation warning for Flutter SDK version compatibility
    // ignore: deprecated_member_use
    final radio = SizedBox(
      width: SpacingSystem.minTouchTarget,
      height: SpacingSystem.minTouchTarget,
      // ignore: deprecated_member_use
      child: Radio<T>(
        value: value,
        // ignore: deprecated_member_use
        groupValue: groupValue,
        // ignore: deprecated_member_use
        onChanged: onChanged,
        activeColor: ColorPalette.primary,
      ),
    );

    if (label == null) return radio;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          radio,
          const SizedBox(width: SpacingSystem.xs),
          Text(label!, style: TypographyScale.bodyLarge),
        ],
      ),
    );
  }
}
