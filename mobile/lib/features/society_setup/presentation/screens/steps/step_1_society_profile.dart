import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivaas_mobile/app/config/theme/spacing_system.dart';
import 'package:nivaas_mobile/app/config/theme/typography_scale.dart';
import 'package:nivaas_mobile/features/society_setup/domain/entities/society_profile.dart';
import 'package:nivaas_mobile/features/society_setup/presentation/providers/society_setup_controller.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_dropdown.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_phone_field.dart';
import 'package:nivaas_mobile/shared/widgets/inputs/nivaas_text_field.dart';
import 'package:nivaas_mobile/shared/widgets/layout/nivaas_gap.dart';

class Step1SocietyProfile extends ConsumerStatefulWidget {
  const Step1SocietyProfile({super.key});

  @override
  ConsumerState<Step1SocietyProfile> createState() => _Step1SocietyProfileState();
}

class _Step1SocietyProfileState extends ConsumerState<Step1SocietyProfile> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pinController;
  late TextEditingController _phoneController;
  late TextEditingController _regController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(societySetupControllerProvider).profile;
    _nameController = TextEditingController(text: profile.name);
    _addressController = TextEditingController(text: profile.address);
    _cityController = TextEditingController(text: profile.city);
    _stateController = TextEditingController(text: profile.state);
    _pinController = TextEditingController(text: profile.pinCode);
    _phoneController = TextEditingController(text: profile.contactNumber);
    _regController = TextEditingController(text: profile.registrationNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    _phoneController.dispose();
    _regController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final state = ref.read(societySetupControllerProvider);
    final controller = ref.read(societySetupControllerProvider.notifier);
    controller.updateProfile(state.profile.copyWith(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinController.text.trim(),
      contactNumber: _phoneController.text.trim(),
      registrationNumber: _regController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(societySetupControllerProvider);
    final controller = ref.watch(societySetupControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(SpacingSystem.m),
      children: [
        const Text(
          'Society Profile Details',
          style: TypographyScale.headingLarge,
        ),
        const SizedBox(height: SpacingSystem.xs),
        const Text(
          'Enter basic information about your residential apartment or housing society.',
          style: TypographyScale.bodyMedium,
        ),
        const NivaasGap.l(),
        NivaasTextField(
          label: 'Society Name *',
          hintText: 'e.g. Green Park Apartments RWA',
          controller: _nameController,
          onChanged: (_) => _onFieldChanged(),
        ),
        const NivaasGap.m(),
        NivaasDropdown<SocietyType>(
          label: 'Society Type *',
          value: setupState.profile.type,
          items: SocietyType.values
              .map((type) => NivaasDropdownItem(value: type, label: type.displayName))
              .toList(),
          onChanged: (val) {
            controller.updateProfile(setupState.profile.copyWith(type: val));
          },
        ),
        const NivaasGap.m(),
        NivaasTextField(
          label: 'Address / Street *',
          hintText: 'e.g. Plot 42, Sector 18, Dwarka',
          controller: _addressController,
          onChanged: (_) => _onFieldChanged(),
        ),
        const NivaasGap.m(),
        Row(
          children: [
            Expanded(
              child: NivaasTextField(
                label: 'City *',
                hintText: 'e.g. New Delhi',
                controller: _cityController,
                onChanged: (_) => _onFieldChanged(),
              ),
            ),
            const SizedBox(width: SpacingSystem.m),
            Expanded(
              child: NivaasTextField(
                label: 'State *',
                hintText: 'e.g. Delhi',
                controller: _stateController,
                onChanged: (_) => _onFieldChanged(),
              ),
            ),
          ],
        ),
        const NivaasGap.m(),
        Row(
          children: [
            Expanded(
              child: NivaasTextField(
                label: 'PIN Code *',
                hintText: '110075',
                keyboardType: TextInputType.number,
                controller: _pinController,
                onChanged: (_) => _onFieldChanged(),
              ),
            ),
            const SizedBox(width: SpacingSystem.m),
            Expanded(
              child: NivaasPhoneField(
                controller: _phoneController,
                onChanged: (_) => _onFieldChanged(),
              ),
            ),
          ],
        ),
        const NivaasGap.m(),
        NivaasTextField(
          label: 'Registration Number (Optional)',
          hintText: 'e.g. RWA/DEL/2024/9812',
          controller: _regController,
          onChanged: (_) => _onFieldChanged(),
        ),
      ],
    );
  }
}
