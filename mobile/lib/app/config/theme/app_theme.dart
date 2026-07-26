import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'radius_system.dart';
import 'semantic_colors.dart';
import 'spacing_system.dart';
import 'typography_scale.dart';

/// Material 3 AppTheme builder for Nivaas.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: TypographyScale.fontFamily,
      scaffoldBackgroundColor: ColorPalette.background,
      extensions: const [
        SemanticColors.light,
      ],
      colorScheme: const ColorScheme.light(
        primary: ColorPalette.primary,
        onPrimary: Colors.white,
        primaryContainer: ColorPalette.primaryContainer,
        secondary: ColorPalette.secondary,
        onSecondary: Colors.white,
        error: ColorPalette.error,
        onError: Colors.white,
        errorContainer: ColorPalette.errorContainer,
        surface: ColorPalette.surface,
        onSurface: ColorPalette.textPrimary,
        outline: ColorPalette.outline,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.background,
        elevation: 0,
        scrolledUnderElevation: 1.0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ColorPalette.textPrimary),
        titleTextStyle: TypographyScale.headingLarge,
      ),
      cardTheme: const CardThemeData(
        color: ColorPalette.surface,
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorPalette.outline, width: 1.0),
          borderRadius: RadiusSystem.radiusM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusM),
          textStyle: TypographyScale.button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorPalette.primary,
          minimumSize: const Size.fromHeight(SpacingSystem.minTouchTarget),
          side: const BorderSide(color: ColorPalette.primary, width: 1.0),
          shape: const RoundedRectangleBorder(borderRadius: RadiusSystem.radiusM),
          textStyle: TypographyScale.button.copyWith(color: ColorPalette.primary),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: ColorPalette.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: SpacingSystem.m, vertical: SpacingSystem.s),
        border: OutlineInputBorder(
          borderRadius: RadiusSystem.radiusM,
          borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusSystem.radiusM,
          borderSide: BorderSide(color: ColorPalette.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusSystem.radiusM,
          borderSide: BorderSide(color: ColorPalette.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: RadiusSystem.radiusM,
          borderSide: BorderSide(color: ColorPalette.error, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorPalette.surface,
        selectedItemColor: ColorPalette.primary,
        unselectedItemColor: ColorPalette.secondary,
        type: BottomNavigationBarType.fixed,
        elevation: 2.0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: TypographyScale.fontFamily,
      scaffoldBackgroundColor: ColorPalette.darkBackground,
      extensions: const [
        SemanticColors.dark,
      ],
      colorScheme: const ColorScheme.dark(
        primary: ColorPalette.darkPrimary,
        onPrimary: ColorPalette.darkBackground,
        secondary: ColorPalette.secondary,
        surface: ColorPalette.darkSurface,
        onSurface: ColorPalette.darkTextPrimary,
        error: ColorPalette.error,
        outline: ColorPalette.darkOutline,
      ),
    );
  }
}
