import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

/// Reusable Modal Bottom Sheet Container matching DESIGN_SYSTEM.md section 16.6.
class NivaasBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const NivaasBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: RadiusSystem.bottomSheetTop,
      ),
      builder: (context) {
        return NivaasBottomSheet(title: title, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle pill
            Center(
              child: Container(
                width: 32.0,
                height: 4.0,
                margin: const EdgeInsets.symmetric(vertical: SpacingSystem.s),
                decoration: BoxDecoration(
                  color: ColorPalette.outline,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingSystem.m),
              child: Text(
                title,
                style: TypographyScale.headingMedium,
              ),
            ),
            const SizedBox(height: SpacingSystem.s),
            const Divider(height: 1.0, color: ColorPalette.outline),
            Padding(
              padding: const EdgeInsets.all(SpacingSystem.m),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
