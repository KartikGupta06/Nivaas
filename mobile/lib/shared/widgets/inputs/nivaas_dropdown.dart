import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';

class NivaasDropdownItem<T> {
  final T value;
  final String label;

  const NivaasDropdownItem({required this.value, required this.label});
}

/// Reusable Accessible Dropdown Component opening a bottom sheet picker on mobile.
class NivaasDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<NivaasDropdownItem<T>> items;
  final ValueChanged<T>? onChanged;
  final String? hintText;

  const NivaasDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.cast<NivaasDropdownItem<T>?>().firstWhere(
          (item) => item?.value == value,
          orElse: () => null,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TypographyScale.headingSmall,
        ),
        const SizedBox(height: SpacingSystem.xs),
        InkWell(
          onTap: () => _showPickerSheet(context),
          borderRadius: RadiusSystem.radiusM,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingSystem.m,
              vertical: SpacingSystem.m,
            ),
            decoration: BoxDecoration(
              color: ColorPalette.surface,
              borderRadius: RadiusSystem.radiusM,
              border: Border.all(color: ColorPalette.outline, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItem?.label ?? hintText!,
                  style: TypographyScale.bodyLarge.copyWith(
                    color: selectedItem != null ? ColorPalette.textPrimary : ColorPalette.textSecondary,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: ColorPalette.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: RadiusSystem.bottomSheetTop,
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.0,
                height: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: ColorPalette.outline,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SpacingSystem.m),
                child: Text(
                  label,
                  style: TypographyScale.headingMedium,
                ),
              ),
              const Divider(height: 1.0, color: ColorPalette.outline),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item.value == value;
                    return ListTile(
                      title: Text(
                        item.label,
                        style: TypographyScale.bodyLarge.copyWith(
                          color: isSelected ? ColorPalette.primary : ColorPalette.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: ColorPalette.primary) : null,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        if (onChanged != null) onChanged!(item.value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
