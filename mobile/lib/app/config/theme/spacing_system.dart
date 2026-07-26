import 'package:flutter/material.dart';

/// 8pt Grid Spacing Tokens according to DESIGN_SYSTEM.md.
abstract class SpacingSystem {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  /// Minimum accessible touch target constraint area (48x48 dp)
  static const double minTouchTarget = 48.0;

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingS = EdgeInsets.all(s);
  static const EdgeInsets paddingM = EdgeInsets.all(m);
  static const EdgeInsets paddingL = EdgeInsets.all(l);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  static const EdgeInsets horizontalM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets verticalM = EdgeInsets.symmetric(vertical: m);
}
