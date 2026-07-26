import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/elevation_system.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';

/// Premium Clickable Card Component with InkWell ripple feedback & micro-shadows.
class NivaasClickableCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  const NivaasClickableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = const EdgeInsets.all(SpacingSystem.m),
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: RadiusSystem.radiusM,
          border: Border.all(color: ColorPalette.outline, width: 1.0),
          boxShadow: ElevationSystem.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: RadiusSystem.radiusM,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius: RadiusSystem.radiusM,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
