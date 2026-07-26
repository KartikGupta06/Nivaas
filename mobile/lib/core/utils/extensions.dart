import 'package:flutter/material.dart';

/// Convenient Extensions on BuildContext for clean UI code.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

/// Convenient Extensions on String.
extension StringX on String {
  String get capitalizeFirst =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  bool get isValidIndianPhone => RegExp(r'^[6-9]\d{9}$').hasMatch(replaceAll(RegExp(r'\D'), ''));
}
