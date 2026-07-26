import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';

/// Reusable Production-Ready Card Widget matching DESIGN_SYSTEM.md.
class NivaasCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;

  const NivaasCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SpacingSystem.m),
    this.backgroundColor,
    this.borderColor,
    this.elevation = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? ColorPalette.surface,
      elevation: elevation,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor ?? ColorPalette.outline,
          width: 1.0,
        ),
        borderRadius: RadiusSystem.radiusM,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
