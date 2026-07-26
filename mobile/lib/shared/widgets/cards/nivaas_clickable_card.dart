import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';

/// Reusable Clickable Card Widget with InkWell ripple feedback & Semantics.
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
      child: Card(
        color: ColorPalette.surface,
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: ColorPalette.outline, width: 1.0),
          borderRadius: RadiusSystem.radiusM,
        ),
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
    );
  }
}
