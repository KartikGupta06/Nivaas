import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'radius_system.dart';
import 'semantic_colors.dart';
import 'spacing_system.dart';
import 'typography_scale.dart';

/// Production Material 3 ThemeData with Premium Slate & Linear tokens.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: TypographyScale.fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorPalette.background,
      colorScheme: const ColorScheme.light(
        primary: ColorPalette.primary,
        onPrimary: Colors.white,
        primaryContainer: ColorPalette.primaryContainer,
        onPrimaryContainer: ColorPalette.primary,
        secondary: ColorPalette.secondary,
        surface: ColorPalette.surface,
        onSurface: ColorPalette.textPrimary,
        outline: ColorPalette.outline,
        error: ColorPalette.error,
        onError: Colors.white,
        errorContainer: ColorPalette.errorContainer,
        onErrorContainer: ColorPalette.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.background,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: ColorPalette.textPrimary),
        titleTextStyle: TypographyScale.headingLarge,
      ),
      cardTheme: const CardThemeData(
        color: ColorPalette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorPalette.outline, width: 1.0),
          borderRadius: RadiusSystem.radiusM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusPill),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        SemanticColors.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: TypographyScale.fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorPalette.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: ColorPalette.darkBackground,
        primaryContainer: ColorPalette.darkSurfaceSubtle,
        onPrimaryContainer: Colors.white,
        secondary: ColorPalette.darkTextSecondary,
        surface: ColorPalette.darkSurface,
        onSurface: ColorPalette.darkTextPrimary,
        outline: ColorPalette.darkOutline,
        error: ColorPalette.error,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.darkBackground,
        elevation: 0,
        titleTextStyle: TypographyScale.headingLarge,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        SemanticColors.dark,
      ],
    );
  }
}
