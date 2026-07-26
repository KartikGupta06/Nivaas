import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Switch Widget matching Material 3 & DESIGN_SYSTEM.md guidelines.
class NivaasSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  const NivaasSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = SizedBox(
      height: SpacingSystem.minTouchTarget,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: ColorPalette.primary,
        activeThumbColor: Colors.white,
        inactiveThumbColor: ColorPalette.secondary,
        inactiveTrackColor: ColorPalette.outline,
      ),
    );

    if (label == null) return switchWidget;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label!, style: TypographyScale.bodyLarge),
        switchWidget,
      ],
    );
  }
}
