import 'package:flutter/animation.dart';

/// Centralized Animation Durations & Curves matching DESIGN_SYSTEM.md (<250ms).
abstract class AnimationSystem {
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);

  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveFastOutSlowIn = Curves.fastOutSlowIn;
}
