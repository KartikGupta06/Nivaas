import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Premium List Tile Component matching Notion Mobile & Apple Settings.
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: RadiusSystem.radiusM,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingSystem.m,
                  vertical: SpacingSystem.s,
                ),
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: SpacingSystem.m),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TypographyScale.headingSmall,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2.0),
                            Text(
                              subtitle!,
                              style: TypographyScale.bodyMedium.copyWith(
                                color: ColorPalette.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null)
                      trailing!
                    else if (onTap != null)
                      const Icon(Icons.chevron_right_rounded, color: ColorPalette.textMuted),
                  ],
                ),
              ),
            ),
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
