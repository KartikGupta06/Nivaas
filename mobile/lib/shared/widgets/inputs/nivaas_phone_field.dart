import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Premium Mobile Phone Input with Indian Flag +91 prefix tile.
class NivaasPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const NivaasPhoneField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Mobile Number',
          style: TypographyScale.headingSmall,
        ),
        const SizedBox(height: SpacingSystem.xs),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          onChanged: onChanged,
          decoration: InputDecoration(
            counterText: '',
            hintText: '9876543210',
            hintStyle: TypographyScale.bodyLarge.copyWith(color: ColorPalette.textMuted),
            errorText: errorText,
            filled: true,
            fillColor: ColorPalette.surface,
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              margin: const EdgeInsets.only(right: 12.0),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: ColorPalette.outline, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 18.0)),
                  const SizedBox(width: 6.0),
                  Text(
                    '+91',
                    style: TypographyScale.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
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
          ),
        ),
      ],
    );
  }
}
