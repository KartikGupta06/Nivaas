import 'package:flutter/material.dart';
import 'nivaas_text_field.dart';

/// Reusable Password Field with visibility toggle icon.
class NivaasPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const NivaasPasswordField({
    super.key,
    this.label = 'Password',
    this.controller,
    this.onChanged,
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
      label: widget.label,
      controller: widget.controller,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      obscureText: _obscureText,
      maxLines: 1,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
