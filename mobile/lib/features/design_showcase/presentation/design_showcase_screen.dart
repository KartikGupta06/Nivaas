import 'package:flutter/material.dart';
import '../../../app/config/theme/color_palette.dart';
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

/// Developer-Only Component Showcase Screen previewing every Nivaas Design System component.
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
    _tabController = TabController(length: 7, vsync: this);
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
        title: 'Nivaas Design Showcase',
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: ColorPalette.primary,
            unselectedLabelColor: ColorPalette.textSecondary,
            tabs: const [
              Tab(text: 'Buttons'),
              Tab(text: 'Cards'),
              Tab(text: 'Inputs'),
              Tab(text: 'Chips & Badges'),
              Tab(text: 'Navigation'),
              Tab(text: 'Feedback'),
              Tab(text: 'Typography'),
            ],
          ),
          const NivaasDivider(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildButtonsTab(),
                _buildCardsTab(),
                _buildInputsTab(),
                _buildChipsTab(),
                _buildNavigationTab(),
                _buildFeedbackTab(),
                _buildTypographyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Button Variants'),
        const NivaasGap.m(),
        NivaasButton.primary(
          label: 'Primary Pill Action',
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
          label: 'Secondary Action',
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
              icon: Icons.notifications_none,
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
        const NivaasSectionHeader(title: 'Standard Surface Card'),
        const NivaasGap.s(),
        const NivaasCard(
          child: Text('Base Card with 1dp border and 8dp corner radius.'),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Clickable Card (Ripple Feedback)'),
        const NivaasGap.s(),
        NivaasClickableCard(
          onTap: () {},
          child: const Text('Tap me to test haptic ripple feedback!'),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Info & Status Cards'),
        const NivaasGap.s(),
        const NivaasInfoCard.info(
          title: 'Gate Entry Approved',
          subtitle: 'Swiggy delivery boy logged for Flat A-402',
        ),
        const NivaasGap.s(),
        const NivaasInfoCard.warning(
          title: 'Maintenance Dues Pending',
          subtitle: 'Invoice #1042 due on 30th July',
        ),
        const NivaasGap.s(),
        const NivaasInfoCard.success(
          title: 'Payment Successful',
          subtitle: 'Receipt #9812 generated',
        ),
        const NivaasGap.s(),
        const NivaasInfoCard.error(
          title: 'Visitor Denied',
          subtitle: 'Unknown guest entry blocked by resident',
        ),
      ],
    );
  }

  Widget _buildInputsTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Form Inputs'),
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
          label: 'Select Wing / Block',
          value: _dropdownVal,
          items: const [
            NivaasDropdownItem(value: 'A', label: 'Block A'),
            NivaasDropdownItem(value: 'B', label: 'Block B'),
            NivaasDropdownItem(value: 'C', label: 'Block C'),
          ],
          onChanged: (val) => setState(() => _dropdownVal = val),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: '6-Digit OTP Field'),
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
        const NivaasSectionHeader(title: 'Status Chips'),
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
          label: 'Allow instant delivery entry',
          onChanged: (val) => setState(() => _checkboxVal = val ?? false),
        ),
        const NivaasGap.s(),
        NivaasRadio<int>(
          value: 1,
          groupValue: _radioVal,
          label: 'Notify via Push Notification',
          onChanged: (val) => setState(() => _radioVal = val ?? 1),
        ),
        NivaasRadio<int>(
          value: 2,
          groupValue: _radioVal,
          label: 'Notify via WhatsApp Message',
          onChanged: (val) => setState(() => _radioVal = val ?? 2),
        ),
        const NivaasGap.s(),
        NivaasSwitch(
          value: _switchVal,
          label: 'High Contrast Mode',
          onChanged: (val) => setState(() => _switchVal = val),
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Filter Chip & Badges'),
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
              count: 5,
              child: Icon(Icons.notifications, size: 32.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'List Tiles & Avatars'),
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
          subtitle: 'Entry 06:45 PM • Main Gate',
          leading: const NivaasAvatar(name: 'Sunil Kumar'),
          trailing: const NivaasStatusChip.inside(),
          onTap: () {},
        ),
        const NivaasGap.m(),
        const NivaasSectionHeader(title: 'Modals & Sheets'),
        const NivaasGap.s(),
        NivaasButton.outlined(
          label: 'Trigger Confirmation Dialog',
          onPressed: () {
            NivaasDialog.showConfirmation(
              context: context,
              title: 'Deny Visitor Entry?',
              message: 'Are you sure you want to deny entry to this guest?',
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
                  const NivaasTextField(label: 'Guest Name'),
                  const NivaasGap.m(),
                  NivaasButton.primary(
                    label: 'Generate Gate Code',
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

  Widget _buildFeedbackTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Progress Loaders'),
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
          message: 'When guests or deliveries arrive at the gate, they will appear here.',
        ),
      ],
    );
  }

  Widget _buildTypographyTab() {
    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const NivaasSectionHeader(title: 'Type Scale System'),
        const NivaasGap.s(),
        const Text('Display Large (28sp)', style: TypographyScale.displayLarge),
        const NivaasGap.s(),
        const Text('Heading Large (22sp)', style: TypographyScale.headingLarge),
        const NivaasGap.s(),
        const Text('Heading Medium (18sp)', style: TypographyScale.headingMedium),
        const NivaasGap.s(),
        const Text('Heading Small (16sp)', style: TypographyScale.headingSmall),
        const NivaasGap.s(),
        const Text('Body Large (16sp)', style: TypographyScale.bodyLarge),
        const NivaasGap.s(),
        const Text('Body Medium (14sp)', style: TypographyScale.bodyMedium),
        const NivaasGap.s(),
        const Text('Caption (12sp)', style: TypographyScale.caption),
        const NivaasGap.l(),
        const NivaasSectionHeader(title: 'Info Key-Value Rows'),
        const NivaasGap.s(),
        const NivaasInfoRow(label: 'Society Name', value: 'Green Park Apts'),
        const NivaasInfoRow(label: 'Flat Unit', value: 'A-402'),
        const NivaasInfoRow(label: 'Role', value: 'Resident Owner'),
      ],
    );
  }
}
