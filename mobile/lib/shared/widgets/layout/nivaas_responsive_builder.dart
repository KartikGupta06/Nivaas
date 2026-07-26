import 'package:flutter/material.dart';

/// Reusable Responsive Breakpoint Builder for Mobile vs Tablet layouts.
class NivaasResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;

  const NivaasResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
  });

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600.0;
  }

  @override
  Widget build(BuildContext context) {
    if (isTablet(context) && tablet != null) {
      return tablet!(context);
    }
    return mobile(context);
  }
}
