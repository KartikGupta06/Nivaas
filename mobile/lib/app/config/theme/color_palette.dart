import 'package:flutter/material.dart';

/// Centralized Color Tokens for Nivaas.
/// Strictly follows DESIGN_SYSTEM.md specifications.
abstract class ColorPalette {
  /// Primary Brand Color - Google Blue (Trust & Clarity)
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryContainer = Color(0xFFE8F0FE);

  /// Secondary Color - Neutral Slate
  static const Color secondary = Color(0xFF5F6368);

  /// Success / Approved Status Color - Deep Accessible Green
  static const Color success = Color(0xFF188038);
  static const Color successContainer = Color(0xFFE6F4EA);

  /// Warning / Pending Status Color - Warm Amber
  static const Color warning = Color(0xFFE37400);
  static const Color warningContainer = Color(0xFFFEF7E0);

  /// Error / Denied / SOS Status Color - Deep Accessible Red
  static const Color error = Color(0xFFD93025);
  static const Color errorContainer = Color(0xFFFCE8E6);

  /// Text Colors (High Contrast Charcoal & Medium Slate)
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textDisabled = Color(0x611C1B1F); // 38% Opacity

  /// Canvas & Surface Colors
  static const Color background = Color(0xFFF8F9FA); // Off-White Canvas
  static const Color surface = Color(0xFFFFFFFF);     // Pure White Surface
  static const Color outline = Color(0xFFC7C5D0);     // Subtle Gray Border

  // Dark Mode Palette Overrides
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF8AB4F8);
  static const Color darkTextPrimary = Color(0xFFE6E1E5);
  static const Color darkTextSecondary = Color(0xFFCAC4D0);
  static const Color darkOutline = Color(0xFF49454F);
}
