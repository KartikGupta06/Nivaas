import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable 6-digit OTP Pin Field Layout.
class NivaasOtpField extends StatefulWidget {
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const NivaasOtpField({
    super.key,
    this.onCompleted,
    this.onChanged,
  });

  @override
  State<NivaasOtpField> createState() => _NivaasOtpFieldState();
}

class _NivaasOtpFieldState extends State<NivaasOtpField> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onTextChange(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    final code = _otp;
    if (widget.onChanged != null) widget.onChanged!(code);
    if (code.length == 6 && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 44.0,
          height: 54.0,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TypographyScale.displayLarge,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: ColorPalette.surface,
              border: OutlineInputBorder(
                borderRadius: RadiusSystem.radiusM,
                borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: RadiusSystem.radiusM,
                borderSide: BorderSide(color: ColorPalette.primary, width: 2.0),
              ),
            ),
            onChanged: (value) => _onTextChange(index, value),
          ),
        );
      }),
    );
  }
}
