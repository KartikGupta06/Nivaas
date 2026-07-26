import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Notification Count Badge.
class NivaasBadge extends StatelessWidget {
  final int count;
  final Widget? child;

  const NivaasBadge({
    super.key,
    required this.count,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child ?? const SizedBox.shrink();

    final badgeContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: const BoxDecoration(
        color: ColorPalette.error,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(
        minWidth: 18.0,
        minHeight: 18.0,
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: TypographyScale.caption.copyWith(
            color: Colors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (child == null) return badgeContent;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        child!,
        Positioned(
          right: 0,
          top: 0,
          child: badgeContent,
        ),
      ],
    );
  }
}
