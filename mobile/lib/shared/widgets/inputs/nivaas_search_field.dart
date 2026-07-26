import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Pill-shaped Search Field matching DESIGN_SYSTEM.md guidelines.
class NivaasSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const NivaasSearchField({
    super.key,
    this.hintText = 'Search visitors, flats, notices...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: TypographyScale.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, color: ColorPalette.textSecondary),
        suffixIcon: (controller?.text.isNotEmpty ?? false)
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20.0),
                onPressed: () {
                  controller?.clear();
                  if (onChanged != null) onChanged!('');
                  if (onClear != null) onClear!();
                },
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF1F3F4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingSystem.m,
          vertical: SpacingSystem.s,
        ),
        border: const OutlineInputBorder(
          borderRadius: RadiusSystem.radiusPill,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: RadiusSystem.radiusPill,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: RadiusSystem.radiusPill,
          borderSide: BorderSide(color: ColorPalette.primary, width: 1.5),
        ),
      ),
    );
  }
}
