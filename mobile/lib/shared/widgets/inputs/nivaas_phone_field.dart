import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Indian Phone Number Field with +91 country prefix tile.
class NivaasPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool enabled;

  const NivaasPhoneField({
    super.key,
    this.controller,
    this.onChanged,
    this.errorText,
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
          onChanged: onChanged,
          enabled: enabled,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: TypographyScale.bodyLarge,
          decoration: InputDecoration(
            hintText: '98765 43210',
            errorText: errorText,
            counterText: '',
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: SpacingSystem.m),
              margin: const EdgeInsets.only(right: SpacingSystem.s),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: ColorPalette.outline, width: 1.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇮🇳', style: TextStyle(fontSize: 18.0)),
                  SizedBox(width: 6.0),
                  Text(
                    '+91',
                    style: TypographyScale.headingSmall,
                  ),
                ],
              ),
            ),
            filled: true,
            fillColor: ColorPalette.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpacingSystem.m,
              vertical: SpacingSystem.m,
            ),
            border: const OutlineInputBorder(
              borderRadius: RadiusSystem.radiusM,
              borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
