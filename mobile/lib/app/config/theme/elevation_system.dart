import 'package:flutter/material.dart';

/// Centralized Elevation Tokens matching DESIGN_SYSTEM.md.
abstract class ElevationSystem {
  static const double level0 = 0.0; // Flat canvas, input background
  static const double level1 = 1.0; // Card surface elevation
  static const double level2 = 2.0; // Sticky bottom navigation, FAB
  static const double level3 = 4.0; // Bottom sheets, modal sheets
  static const double level4 = 8.0; // Emergency SOS full-screen alert

  /// Accessible low-GPU shadow for elevated cards
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F000000), // 6% black opacity
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}
