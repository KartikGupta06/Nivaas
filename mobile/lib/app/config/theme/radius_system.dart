import 'package:flutter/material.dart';

/// Premium Soft Corner Radius Tokens matching Apple Settings & Google Wallet aesthetics.
abstract class RadiusSystem {
  static const double s = 8.0; // Small Chips, Badges, Tags
  static const double m = 16.0; // Cards, Input Fields, List Tiles
  static const double l = 24.0; // Bottom Sheets, Dialog Containers, Action Cards
  static const double xl = 32.0; // Large Display Headers
  static const double pill = 100.0; // Pill Buttons, Search Bars, Status Badges

  static const BorderRadius radiusS = BorderRadius.all(Radius.circular(s));
  static const BorderRadius radiusM = BorderRadius.all(Radius.circular(m));
  static const BorderRadius radiusL = BorderRadius.all(Radius.circular(l));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(pill));

  static const BorderRadius bottomSheetTop = BorderRadius.vertical(top: Radius.circular(l));
}
