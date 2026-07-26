import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Production-Ready Input Text Field Widget.
class NivaasTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const NivaasTextField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TypographyScale.headingSmall.copyWith(
            color: enabled ? ColorPalette.textPrimary : ColorPalette.textDisabled,
          ),
        ),
        const SizedBox(height: SpacingSystem.xs),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          style: TypographyScale.bodyLarge.copyWith(
            color: enabled ? ColorPalette.textPrimary : ColorPalette.textDisabled,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? ColorPalette.surface : ColorPalette.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpacingSystem.m,
              vertical: SpacingSystem.m,
            ),
            border: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.primary, width: 2.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
