import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';

/// Reusable Icon Button strictly enforcing 48x48 dp minimum touch target area.
class NivaasIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double iconSize;

  const NivaasIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: iconSize, color: color ?? ColorPalette.textPrimary),
      onPressed: onPressed,
      tooltip: tooltip,
      constraints: const BoxConstraints(
        minWidth: SpacingSystem.minTouchTarget,
        minHeight: SpacingSystem.minTouchTarget,
      ),
    );
  }
}
