import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';

/// Reusable Skeleton Shimmer Loader matching card & list layout shapes.
class NivaasSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const NivaasSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = RadiusSystem.m,
  });

  const NivaasSkeleton.card({
    super.key,
    this.width = double.infinity,
    this.height = 100.0,
    this.borderRadius = RadiusSystem.m,
  });

  const NivaasSkeleton.text({
    super.key,
    this.width = 150.0,
    this.height = 16.0,
    this.borderRadius = RadiusSystem.s,
  });

  @override
  State<NivaasSkeleton> createState() => _NivaasSkeletonState();
}

class _NivaasSkeletonState extends State<NivaasSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: ColorPalette.outline.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
