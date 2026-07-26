import 'package:flutter/material.dart';

/// Premium Modern Color Tokens for Nivaas Design System.
/// Inspired by Linear, Notion Mobile, Google Wallet, and Apple Health.
abstract class ColorPalette {
  // Brand & Primary Tokens (Slate Ink & Linear Blue)
  static const Color primary = Color(0xFF0F172A); // Slate 900 (Obsidian/Ink)
  static const Color primaryAccent = Color(0xFF2563EB); // Linear Blue Accent
  static const Color primaryContainer = Color(0xFFF1F5F9); // Slate 100
  static const Color secondary = Color(0xFF475569); // Slate 600

  // Neutral Background & Surface Tokens
  static const Color background = Color(0xFFF8FAFC); // Slate 50 Canvas
  static const Color surface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Light Slate Fill
  static const Color outline = Color(0xFFE2E8F0); // Subtle Border Divider
  static const Color outlineVariant = Color(0xFFCBD5E1); // Medium Border Divider

  // Typography Tokens
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900 High Contrast
  static const Color textSecondary = Color(0xFF64748B); // Slate 500 Subtitle
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400 Muted
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate 300 Disabled

  // Status & Semantic Tokens (Emerald, Warm Amber, Crimson Red)
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color successContainer = Color(0xFFECFDF5); // Emerald 50
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningContainer = Color(0xFFFFFBEB); // Amber 50
  static const Color error = Color(0xFFDC2626); // Crimson Red 600
  static const Color errorContainer = Color(0xFFFEF2F2); // Red 50
  static const Color info = Color(0xFF0284C7); // Sky Blue 600
  static const Color infoContainer = Color(0xFFF0F9FF); // Sky Blue 50

  // Dark Mode Tokens
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceSubtle = Color(0xFF334155);
  static const Color darkOutline = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
