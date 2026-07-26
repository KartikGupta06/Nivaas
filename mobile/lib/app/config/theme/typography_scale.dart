import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Centralized Typography Scale according to DESIGN_SYSTEM.md.
abstract class TypographyScale {
  static const String fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 34.0 / 28.0,
    letterSpacing: -0.5,
    color: ColorPalette.textPrimary,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 28.0 / 22.0,
    letterSpacing: 0.0,
    color: ColorPalette.textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 24.0 / 18.0,
    letterSpacing: 0.15,
    color: ColorPalette.textPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 22.0 / 16.0,
    letterSpacing: 0.15,
    color: ColorPalette.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0,
    letterSpacing: 0.5,
    color: ColorPalette.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20.0 / 14.0,
    letterSpacing: 0.25,
    color: ColorPalette.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 16.0 / 12.0,
    letterSpacing: 0.4,
    color: ColorPalette.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 24.0 / 16.0,
    letterSpacing: 0.5,
    color: Colors.white,
  );
}
