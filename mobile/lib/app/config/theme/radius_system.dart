import 'package:flutter/material.dart';

/// Corner Radius Tokens according to DESIGN_SYSTEM.md.
abstract class RadiusSystem {
  static const double none = 0.0;
  static const double s = 4.0;
  static const double m = 8.0;      // Standard Card & Input Radius
  static const double l = 16.0;     // Bottom Sheet Top Radius
  static const double pill = 24.0;  // Pill Buttons & Search Bar Radius

  static const BorderRadius radiusS = BorderRadius.all(Radius.circular(s));
  static const BorderRadius radiusM = BorderRadius.all(Radius.circular(m));
  static const BorderRadius radiusL = BorderRadius.all(Radius.circular(l));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(pill));

  static const BorderRadius bottomSheetTop = BorderRadius.only(
    topLeft: Radius.circular(l),
    topRight: Radius.circular(l),
  );
}
