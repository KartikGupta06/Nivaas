import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';

/// Reusable Circular & Linear Progress Loaders.
class NivaasLoader extends StatelessWidget {
  final double size;
  final Color color;

  const NivaasLoader({
    super.key,
    this.size = 36.0,
    this.color = ColorPalette.primary,
  });

  static Widget linear({Color color = ColorPalette.primary}) {
    return LinearProgressIndicator(
      color: color,
      backgroundColor: ColorPalette.primaryContainer,
      minHeight: 4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
