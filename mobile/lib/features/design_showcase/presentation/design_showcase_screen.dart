import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
import '../../../app/config/theme/radius_system.dart';
import '../../../app/config/theme/spacing_system.dart';
import '../../../app/config/theme/typography_scale.dart';
import '../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../shared/widgets/buttons/nivaas_icon_button.dart';
import '../../../shared/widgets/cards/nivaas_card.dart';
import '../../../shared/widgets/cards/nivaas_clickable_card.dart';
import '../../../shared/widgets/cards/nivaas_info_card.dart';
import '../../../shared/widgets/feedback/nivaas_empty_state.dart';
import '../../../shared/widgets/feedback/nivaas_loader.dart';
import '../../../shared/widgets/feedback/nivaas_skeleton.dart';
import '../../../shared/widgets/inputs/nivaas_dropdown.dart';
import '../../../shared/widgets/inputs/nivaas_otp_field.dart';
import '../../../shared/widgets/inputs/nivaas_password_field.dart';
import '../../../shared/widgets/inputs/nivaas_phone_field.dart';
import '../../../shared/widgets/inputs/nivaas_search_field.dart';
import '../../../shared/widgets/inputs/nivaas_text_field.dart';
import '../../../shared/widgets/layout/nivaas_divider.dart';
import '../../../shared/widgets/layout/nivaas_gap.dart';
import '../../../shared/widgets/layout/nivaas_info_row.dart';
import '../../../shared/widgets/modals/nivaas_bottom_sheet.dart';
import '../../../shared/widgets/modals/nivaas_dialog.dart';
import '../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../../../shared/widgets/navigation/nivaas_avatar.dart';
import '../../../shared/widgets/navigation/nivaas_list_tile.dart';
import '../../../shared/widgets/navigation/nivaas_section_header.dart';
import '../../../shared/widgets/selection/nivaas_badge.dart';
import '../../../shared/widgets/selection/nivaas_checkbox.dart';
import '../../../shared/widgets/selection/nivaas_filter_chip.dart';
import '../../../shared/widgets/selection/nivaas_radio.dart';
import '../../../shared/widgets/selection/nivaas_status_chip.dart';
import '../../../shared/widgets/selection/nivaas_switch.dart';

/// Permanent Design System UI Playground & Showcase Screen.
class DesignShowcaseScreen extends StatefulWidget {
  const DesignShowcaseScreen({super.key});

  @override
  State<DesignShowcaseScreen> createState() => _DesignShowcaseScreenState();
}

class _DesignShowcaseScreenState extends State<DesignShowcaseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _checkboxVal = true;
  int _radioVal = 1;
  bool _switchVal = true;
  bool _filterSelected = true;
  String? _dropdownVal = 'A';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NivaasAppBar(
        title: 'Nivaas UI Playground',
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: ColorPalette.primaryAccent,
            unselectedLabelColor: ColorPalette.textSecondary,
            indicatorColor: ColorPalette.primaryAccent,
            tabs: const [
              Tab(text: 'Typography & Colors'),
              Tab(text: 'Buttons & Icons'),
              Tab(text: 'Cards & Elevation'),
              Tab(text: 'Inputs & Forms'),
              Tab(text: 'Chips & Badges'),
              Tab(text: 'Dialogs & Sheets'),
              Tab(text: 'Navigation & Tiles'),
              Tab(text: 'Loaders & States'),
              Tab(text: 'Spacing & Radius'),
            ],
          ),
          const NivaasDivider(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTypographyColorsTab(),
                _buildButtonsTab(),
                _buildCardsTab(),
                _buildInputsTab(),
                _buildChipsTab(),
                _buildDialogsTab(),
                _buildNavigationTab(),
                _buildLoadersTab(),
                _buildSpacingRadiusTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypographyColorsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Color Palette Tokens'),
        const NivaasGap.s(),
        Wrap(
          spacing: SpacingSystem.s,
          runSpacing: SpacingSystem.s,
          children: [
            _buildColorSwatch('Primary Ink', ColorPalette.primary, Colors.white),
            _buildColorSwatch('Accent Blue', ColorPalette.primaryAccent, Colors.white),
            _buildColorSwatch('Success', ColorPalette.success, Colors.white),
            _buildColorSwatch('Warning', ColorPalette.warning, Colors.white),
            _buildColorSwatch('Error', ColorPalette.error, Colors.white),
            _buildColorSwatch('Canvas', ColorPalette.background, ColorPalette.textPrimary),
            _buildColorSwatch('Surface', ColorPalette.surface, ColorPalette.textPrimary),
          ],
        ),
        const NivaasGap.l(),
        const NivaasSectionHeader(title: 'Typography Scale (Inter)'),
        const NivaasGap.s(),
        const Text('Display Large (28sp W700)', style: TypographyScale.displayLarge),
        const NivaasGap.s(),
        const Text('Heading Large (22sp W700)', style: TypographyScale.headingLarge),
        const NivaasGap.s(),
        const Text('Heading Medium (18sp W600)', style: TypographyScale.headingMedium),
        const NivaasGap.s(),
        const Text('Heading Small (16sp W600)', style: TypographyScale.headingSmall),
        const NivaasGap.s(),
        const Text('Body Large (16sp W400)', style: TypographyScale.bodyLarge),
        const NivaasGap.s(),
        const Text('Body Medium (14sp W400)', style: TypographyScale.bodyMedium),
        const NivaasGap.s(),
        const Text('Caption / Tag (12sp W600)', style: TypographyScale.caption),
      ],
    );
  }

  Widget _buildColorSwatch(String label, Color color, Color textColor) {
    return Container(
      width: 100.0,
      height: 70.0,
      padding: const EdgeInsets.all(SpacingSystem.xs),
      decoration: BoxDecoration(
        color: color,
        borderRadius: RadiusSystem.radiusM,
        border: Border.all(color: ColorPalette.outline, width: 1.0),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          label,
          style: TypographyScale.caption.copyWith(color: textColor),
        ),
      ),
    );
  }

  Widget _buildButtonsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Button Variants (Full Pill Shape)'),
        const NivaasGap.m(),
        NivaasButton.primary(
          label: 'Primary Action',
          onPressed: () {},
        ),
        const NivaasGap.m(),
        NivaasButton.primary(
          label: 'Primary Loading Action',
          isLoading: true,
          onPressed: () {},
        ),
        const NivaasGap.m(),
        NivaasButton.secondary(
          label: 'Secondary Soft Fill',
          onPressed: () {},
        ),
        const NivaasGap.m(),
        NivaasButton.outlined(
          label: 'Outlined Action',
          onPressed: () {},
        ),
        const NivaasGap.m(),
        NivaasButton.danger(
          label: 'Emergency / Deny Action',
          onPressed: () {},
        ),
        const NivaasGap.m(),
        Row(
          children: [
            NivaasButton.text(
              label: 'Text Action',
              onPressed: () {},
            ),
            const Spacer(),
            NivaasIconButton(
              icon: Icons.notifications_outlined,
              onPressed: () {},
              tooltip: 'Notifications',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Standard Surface Card (16dp Radius)'),
        const NivaasGap.s(),
        const NivaasCard(
          child: Text('Base Card with 16dp rounded radius & multi-layered soft micro-shadows.'),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Clickable Card (Ripple + Haptic)'),
        const NivaasGap.s(),
        NivaasClickableCard(
          onTap: () {},
          child: const Text('Tap me to experience subtle haptic ripple feedback!'),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Tinted Status Cards'),
        const NivaasGap.s(),
        const NivaasInfoCard.info(
          title: 'Gate Entry Logged',
          subtitle: 'Delivery person entered via Gate 1',
        ),
        const NivaasGap.s(),
        const NivaasInfoCard.warning(
          title: 'Maintenance Dues Pending',
          subtitle: 'Invoice #1042 due in 3 days',
        ),
        const NivaasGap.s(),
        const NivaasInfoCard.success(
          title: 'Payment Successful',
          subtitle: 'Receipt #9812 generated',
        ),
        const NivaasGap.s(),
        const NivaasInfoCard.error(
          title: 'Visitor Entry Denied',
          subtitle: 'Blocked by flat resident',
        ),
      ],
    );
  }

  Widget _buildInputsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Form Input Fields'),
        const NivaasGap.s(),
        const NivaasTextField(
          label: 'Full Name',
          hintText: 'e.g. Ramesh Sharma',
        ),
        const NivaasGap.m(),
        const NivaasPhoneField(),
        const NivaasGap.m(),
        const NivaasPasswordField(),
        const NivaasGap.m(),
        const NivaasSearchField(),
        const NivaasGap.m(),
        NivaasDropdown<String>(
          label: 'Select Block / Wing',
          value: _dropdownVal,
          items: const [
            NivaasDropdownItem(value: 'A', label: 'Block A'),
            NivaasDropdownItem(value: 'B', label: 'Block B'),
            NivaasDropdownItem(value: 'C', label: 'Block C'),
          ],
          onChanged: (val) => setState(() => _dropdownVal = val),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: '6-Digit Pin Field'),
        const NivaasGap.s(),
        NivaasOtpField(
          onCompleted: (otp) {},
        ),
      ],
    );
  }

  Widget _buildChipsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Status Pill Badges'),
        const NivaasGap.s(),
        const Wrap(
          spacing: SpacingSystem.s,
          runSpacing: SpacingSystem.s,
          children: [
            NivaasStatusChip.approved(),
            NivaasStatusChip.pending(),
            NivaasStatusChip.denied(),
            NivaasStatusChip.inside(),
            NivaasStatusChip.exited(),
            NivaasStatusChip.overdue(),
          ],
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Selection Controls'),
        const NivaasGap.s(),
        NivaasCheckbox(
          value: _checkboxVal,
          label: 'Allow instant delivery auto-approval',
          onChanged: (val) => setState(() => _checkboxVal = val ?? false),
        ),
        const NivaasGap.s(),
        NivaasRadio<int>(
          value: 1,
          groupValue: _radioVal,
          label: 'Push Notification',
          onChanged: (val) => setState(() => _radioVal = val ?? 1),
        ),
        NivaasRadio<int>(
          value: 2,
          groupValue: _radioVal,
          label: 'WhatsApp Alert',
          onChanged: (val) => setState(() => _radioVal = val ?? 2),
        ),
        const NivaasGap.s(),
        NivaasSwitch(
          value: _switchVal,
          label: 'High Contrast Mode',
          onChanged: (val) => setState(() => _switchVal = val),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Filter Chips & Badges'),
        const NivaasGap.s(),
        Row(
          children: [
            NivaasFilterChip(
              label: 'All Visitors',
              isSelected: _filterSelected,
              onSelected: (val) => setState(() => _filterSelected = val),
            ),
            const NivaasGap.m(isHorizontal: true),
            const NivaasBadge(
              count: 3,
              child: Icon(Icons.notifications_none_rounded, size: 28.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDialogsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Dialogs & Bottom Sheets (24dp Radius)'),
        const NivaasGap.m(),
        NivaasButton.outlined(
          label: 'Open Confirmation Dialog',
          onPressed: () {
            NivaasDialog.showConfirmation(
              context: context,
              title: 'Deny Gate Entry?',
              message: 'Are you sure you want to block this delivery visitor?',
            );
          },
        ),
        const NivaasGap.m(),
        NivaasButton.outlined(
          label: 'Open Modal Bottom Sheet',
          onPressed: () {
            NivaasBottomSheet.show<void>(
              context: context,
              title: 'Pre-Approve Guest',
              child: Column(
                children: [
                  const NivaasTextField(label: 'Guest Name', hintText: 'Enter guest name'),
                  const NivaasGap.m(),
                  NivaasButton.primary(
                    label: 'Generate Pass Code',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavigationTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'List Tiles & Profile Avatars'),
        const NivaasGap.s(),
        NivaasListTile(
          title: 'Rajesh Kumar',
          subtitle: 'Flat A-402 • Resident Owner',
          leading: const NivaasAvatar(name: 'Rajesh Kumar'),
          trailing: const NivaasStatusChip.approved(),
          onTap: () {},
        ),
        NivaasListTile(
          title: 'Swiggy Delivery - Sunil',
          subtitle: 'Entry 06:45 PM • Gate 1',
          leading: const NivaasAvatar(name: 'Sunil Kumar'),
          trailing: const NivaasStatusChip.inside(),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLoadersTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Progress Indicators'),
        const NivaasGap.s(),
        const NivaasLoader(),
        const NivaasGap.m(),
        NivaasLoader.linear(),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Skeleton Shimmer Placeholder'),
        const NivaasGap.s(),
        const NivaasSkeleton.card(height: 80.0),
        const NivaasGap.s(),
        const NivaasSkeleton.text(width: 200.0),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Empty State View'),
        const NivaasGap.s(),
        const NivaasEmptyState(
          title: 'No Recent Visitors',
          message: 'When guests or delivery personnel arrive at the gate, they will appear here.',
        ),
      ],
    );
  }

  Widget _buildSpacingRadiusTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Radius System Tokens'),
        const NivaasGap.s(),
        const NivaasInfoRow(label: 'Small (RadiusSystem.s)', value: '8.0dp'),
        const NivaasInfoRow(label: 'Medium (RadiusSystem.m)', value: '16.0dp'),
        const NivaasInfoRow(label: 'Large (RadiusSystem.l)', value: '24.0dp'),
        const NivaasInfoRow(label: 'Pill (RadiusSystem.pill)', value: '100.0dp'),
        const NivaasGap.l(),
        const NivaasSectionHeader(title: 'Spacing Grid Tokens'),
        const NivaasGap.s(),
        const NivaasInfoRow(label: 'xs (SpacingSystem.xs)', value: '4.0dp'),
        const NivaasInfoRow(label: 's (SpacingSystem.s)', value: '8.0dp'),
        const NivaasInfoRow(label: 'm (SpacingSystem.m)', value: '16.0dp'),
        const NivaasInfoRow(label: 'l (SpacingSystem.l)', value: '24.0dp'),
        const NivaasInfoRow(label: 'xl (SpacingSystem.xl)', value: '32.0dp'),
        const NivaasInfoRow(label: 'xxl (SpacingSystem.xxl)', value: '48.0dp'),
      ],
    );
  }
}
