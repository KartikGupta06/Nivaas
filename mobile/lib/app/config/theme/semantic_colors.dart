import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Custom ThemeExtension providing semantic colors across Light & Dark themes.
class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color error;
  final Color errorContainer;

  const SemanticColors({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.error,
    required this.errorContainer,
  });

  static const light = SemanticColors(
    success: ColorPalette.success,
    successContainer: ColorPalette.successContainer,
    warning: ColorPalette.warning,
    warningContainer: ColorPalette.warningContainer,
    error: ColorPalette.error,
    errorContainer: ColorPalette.errorContainer,
  );

  static const dark = SemanticColors(
    success: ColorPalette.success,
    successContainer: Color(0xFF1B382B),
    warning: ColorPalette.warning,
    warningContainer: Color(0xFF3E2723),
    error: ColorPalette.error,
    errorContainer: Color(0xFF421515),
  );

  @override
  ThemeExtension<SemanticColors> copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? error,
    Color? errorContainer,
  }) {
    return SemanticColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
    );
  }

  @override
  ThemeExtension<SemanticColors> lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
    );
  }
}
