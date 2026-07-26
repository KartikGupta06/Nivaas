import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Circle Avatar with fallback initials & screen reader semantics.
class NivaasAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;

  const NivaasAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 20.0,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarWidget = CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: ColorPalette.primaryContainer,
      );
    } else {
      avatarWidget = CircleAvatar(
        radius: radius,
        backgroundColor: ColorPalette.primaryContainer,
        child: Text(
          _initials,
          style: TypographyScale.caption.copyWith(
            color: ColorPalette.primary,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.8,
          ),
        ),
      );
    }

    return Semantics(
      label: 'Profile picture of $name',
      child: avatarWidget,
    );
  }
}
