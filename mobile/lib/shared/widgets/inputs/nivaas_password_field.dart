import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import 'nivaas_text_field.dart';

/// Reusable Password Field Component with visibility toggle icon.
class NivaasPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? errorText;

  const NivaasPasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.errorText,
  });

  @override
  State<NivaasPasswordField> createState() => _NivaasPasswordFieldState();
}

class _NivaasPasswordFieldState extends State<NivaasPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return NivaasTextField(
      controller: widget.controller,
      label: widget.label,
      obscureText: _obscureText,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: ColorPalette.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
