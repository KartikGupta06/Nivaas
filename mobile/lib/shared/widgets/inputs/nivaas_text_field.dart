import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Premium Outlined Input Component with Slate styling & 16dp radius.
class NivaasTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const NivaasTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TypographyScale.headingSmall,
        ),
        const SizedBox(height: SpacingSystem.xs),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          style: TypographyScale.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TypographyScale.bodyLarge.copyWith(
              color: ColorPalette.textMuted,
            ),
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? ColorPalette.surface : ColorPalette.surfaceSubtle,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpacingSystem.m,
              vertical: SpacingSystem.m,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.primaryAccent, width: 2.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.error, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.error, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
