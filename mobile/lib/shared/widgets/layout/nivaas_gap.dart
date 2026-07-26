import 'package:flutter/material.dart';
import '../../../app/config/theme/spacing_system.dart';

/// Reusable Spacing Gap Widget using 8pt grid tokens.
class NivaasGap extends StatelessWidget {
  final double size;
  final bool isHorizontal;

  const NivaasGap(this.size, {super.key, this.isHorizontal = false});

  const NivaasGap.xs({super.key, this.isHorizontal = false}) : size = SpacingSystem.xs;
  const NivaasGap.s({super.key, this.isHorizontal = false}) : size = SpacingSystem.s;
  const NivaasGap.m({super.key, this.isHorizontal = false}) : size = SpacingSystem.m;
  const NivaasGap.l({super.key, this.isHorizontal = false}) : size = SpacingSystem.l;
  const NivaasGap.xl({super.key, this.isHorizontal = false}) : size = SpacingSystem.xl;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return SizedBox(width: size);
    }
    return SizedBox(height: size);
  }
}
