import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

enum NivaasButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  danger,
}

/// Reusable Production-Ready Button Widget matching DESIGN_SYSTEM.md guidelines.
class NivaasButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final NivaasButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool isFullWidth;

  const NivaasButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = NivaasButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
  });

  const NivaasButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = NivaasButtonVariant.primary;

  const NivaasButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = NivaasButtonVariant.secondary;

  const NivaasButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = NivaasButtonVariant.outlined;

  const NivaasButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = false,
  }) : variant = NivaasButtonVariant.text;

  const NivaasButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
  }) : variant = NivaasButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    final child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(),
              ),
            ),
          ),
          const SizedBox(width: SpacingSystem.s),
        ] else if (icon != null) ...[
          Icon(icon, size: 20.0),
          const SizedBox(width: SpacingSystem.s),
        ],
        Text(
          label,
          style: TypographyScale.button.copyWith(
            color: _getTextColor(),
          ),
        ),
      ],
    );

    Widget buttonWidget;

    switch (variant) {
      case NivaasButtonVariant.primary:
        buttonWidget = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: ColorPalette.outline,
            disabledForegroundColor: ColorPalette.textDisabled,
            elevation: 0,
            minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusM),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
        break;

      case NivaasButtonVariant.secondary:
        buttonWidget = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.primaryContainer,
            foregroundColor: ColorPalette.primary,
            elevation: 0,
            minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusM),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
        break;

      case NivaasButtonVariant.outlined:
        buttonWidget = OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorPalette.primary,
            side: const BorderSide(color: ColorPalette.primary, width: 1.0),
            minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusM),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
        break;

      case NivaasButtonVariant.text:
        buttonWidget = TextButton(
          style: TextButton.styleFrom(
            foregroundColor: ColorPalette.primary,
            minimumSize: const Size(SpacingSystem.minTouchTarget, SpacingSystem.minTouchTarget),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
        break;

      case NivaasButtonVariant.danger:
        buttonWidget = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.error,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusM),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
        break;
    }

    final resultWidget = isFullWidth
        ? SizedBox(width: double.infinity, child: buttonWidget)
        : buttonWidget;

    return Semantics(
      button: true,
      enabled: !isDisabled && !isLoading,
      label: label,
      child: resultWidget,
    );
  }

  Color _getTextColor() {
    if (isDisabled) return ColorPalette.textDisabled;
    switch (variant) {
      case NivaasButtonVariant.primary:
      case NivaasButtonVariant.danger:
        return Colors.white;
      case NivaasButtonVariant.secondary:
      case NivaasButtonVariant.outlined:
      case NivaasButtonVariant.text:
        return ColorPalette.primary;
    }
  }

  Color _getLoadingColor() {
    switch (variant) {
      case NivaasButtonVariant.primary:
      case NivaasButtonVariant.danger:
        return Colors.white;
      case NivaasButtonVariant.secondary:
      case NivaasButtonVariant.outlined:
      case NivaasButtonVariant.text:
        return ColorPalette.primary;
    }
  }
}
