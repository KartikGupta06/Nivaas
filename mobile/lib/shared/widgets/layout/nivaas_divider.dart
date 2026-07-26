import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';

/// Reusable 1dp Outline Divider matching DESIGN_SYSTEM.md guidelines.
class NivaasDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const NivaasDivider({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color ?? ColorPalette.outline,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
