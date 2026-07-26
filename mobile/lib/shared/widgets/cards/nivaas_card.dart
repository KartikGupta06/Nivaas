import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/elevation_system.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';

/// Premium Surface Card Component with soft 16dp rounded corners & subtle micro-shadow.
class NivaasCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderSide? borderSide;

  const NivaasCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SpacingSystem.m),
    this.backgroundColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorPalette.surface,
        borderRadius: RadiusSystem.radiusM,
        border: Border.all(
          color: borderSide?.color ?? ColorPalette.outline,
          width: borderSide?.width ?? 1.0,
        ),
        boxShadow: ElevationSystem.cardShadow,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
