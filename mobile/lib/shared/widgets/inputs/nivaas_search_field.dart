import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Premium Full Pill Search Field Component (`RadiusSystem.radiusPill`).
class NivaasSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const NivaasSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search residents, visitors, flats...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TypographyScale.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TypographyScale.bodyLarge.copyWith(color: ColorPalette.textMuted),
        prefixIcon: const Icon(Icons.search_rounded, color: ColorPalette.textSecondary),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, color: ColorPalette.textSecondary),
                onPressed: () {
                  controller?.clear();
                  if (onClear != null) onClear!();
                },
              )
            : null,
        filled: true,
        fillColor: ColorPalette.surfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingSystem.m,
          vertical: SpacingSystem.m,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: RadiusSystem.radiusPill,
          borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: RadiusSystem.radiusPill,
          borderSide: BorderSide(color: ColorPalette.primaryAccent, width: 1.5),
        ),
      ),
    );
  }
}
