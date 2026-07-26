import 'package:flutter/material.dart';

/// Multi-layered Soft Micro-Shadow Tokens matching Apple Health & Linear cards.
abstract class ElevationSystem {
  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 2.0;
  static const double level3 = 4.0;
  static const double level4 = 8.0;

  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 12.0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.02),
      blurRadius: 2.0,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
      blurRadius: 20.0,
      offset: const Offset(0, 8),
    ),
  ];
}
