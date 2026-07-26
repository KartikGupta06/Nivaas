import 'dart:async';
import 'package:flutter/foundation.dart';

/// Generic Throttler utility ensuring action executes at most once per duration.
class Throttler {
  final Duration duration;
  bool _isThrottled = false;

  Throttler({this.duration = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    if (_isThrottled) return;
    _isThrottled = true;
    action();
    Timer(duration, () {
      _isThrottled = false;
    });
  }
}
