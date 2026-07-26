import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Top AppBar Widget matching Material 3 and DESIGN_SYSTEM.md.
class NivaasAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  const NivaasAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TypographyScale.headingLarge),
      centerTitle: false,
      backgroundColor: ColorPalette.background,
      elevation: 0,
      scrolledUnderElevation: 1.0,
      leading: leading ?? (showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorPalette.textPrimary),
              onPressed: () => Navigator.pop(context),
            )
          : null),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
