import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Checkbox Widget enforcing 48dp minimum touch container.
class NivaasCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;

  const NivaasCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final checkbox = SizedBox(
      width: SpacingSystem.minTouchTarget,
      height: SpacingSystem.minTouchTarget,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: ColorPalette.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
    );

    if (label == null) return checkbox;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          const SizedBox(width: SpacingSystem.xs),
          Text(label!, style: TypographyScale.bodyLarge),
        ],
      ),
    );
  }
}
