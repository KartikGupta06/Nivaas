import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Production-Ready List Tile strictly enforcing 64dp minimum height & touch target guidelines.
class NivaasListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const NivaasListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpacingSystem.m,
              vertical: SpacingSystem.xs,
            ),
            leading: leading,
            title: Text(
              title,
              style: TypographyScale.headingSmall,
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: TypographyScale.bodyMedium,
                  )
                : null,
            trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: ColorPalette.textSecondary) : null),
            onTap: onTap,
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: ColorPalette.outline,
            indent: SpacingSystem.m,
            endIndent: SpacingSystem.m,
          ),
      ],
    );
  }
}
