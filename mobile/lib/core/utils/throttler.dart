import 'dart:async';
import 'package:flutter/foundation.dart';

/// Generic Throttler utility ensuring action executes at most once per duration.
class Throttler {
  final Duration duration;
  bool _isThrottled = false;
  Timer? _timer;

  Throttler({this.duration = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    if (_isThrottled) return;
    _isThrottled = true;
    action();
    _timer = Timer(duration, () {
      _isThrottled = false;
    });
  }

  void dispose() {
    _timer?.cancel();
    _isThrottled = false;
  }
}
