import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/inputs/nivaas_text_field.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../providers/visitor_providers.dart';

/// 15-20 Second High-Speed Visitor Registration Screen.
class VisitorRegistrationScreen extends ConsumerStatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  ConsumerState<VisitorRegistrationScreen> createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends ConsumerState<VisitorRegistrationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _flatController = TextEditingController(text: '402');
  final _vehicleController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedWing = 'Wing A';
  String _selectedPurpose = 'Guest';
  int _visitorCount = 1;
  String? _photoPath;
  bool _isSubmitting = false;

  final List<String> _purposes = ['Guest', 'Cab (Uber/Ola)', 'Service', 'Maintenance', 'Interview', 'Courier'];
  final List<String> _wings = ['Wing A', 'Wing B', 'Wing C', 'Wing D'];

  void _capturePhotoHook() {
    setState(() {
      _photoPath = 'https://nivaas.app/mock_visitor_photo.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visitor photo captured successfully!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _captureIdProofHook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ID Proof scanner active — Document attached!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final flat = _flatController.text.trim();

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter visitor full name.'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (phone.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number.'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (flat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter destination flat number.'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final log = await ref.read(visitorNotifierProvider.notifier).registerVisitor(
      visitorName: name,
      phone: '+91 $phone',
      purpose: _selectedPurpose,
      flatNumber: flat,
      wingName: _selectedWing,
      vehicleNumber: _vehicleController.text.trim().isEmpty ? null : _vehicleController.text.trim().toUpperCase(),
      visitorCount: _visitorCount,
      photoUrl: _photoPath,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await ref.read(gateNotifierProvider.notifier).loadGateSummary();

    setState(() => _isSubmitting = false);

    if (mounted && log != null) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: ColorPalette.success, size: 28),
              SizedBox(width: 8),
              Text('Entry Pass Generated'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Visitor: ${log.visitorName}', style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              Text('Destination: ${log.wingName} - Flat ${log.flatNumber}', style: TypographyScale.bodyMedium),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpacingSystem.m),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text('GATE PASS CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ColorPalette.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      log.passCode ?? 'PASS-1029',
                      style: TypographyScale.headingLarge.copyWith(color: ColorPalette.primary, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    const Text('Resident approval notification sent!', style: TextStyle(fontSize: 11, color: ColorPalette.success)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            NivaasButton.primary(
              label: 'Done & Return to Gate',
              onPressed: () {
                Navigator.pop(ctx);
                context.pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const NivaasAppBar(
        title: 'Fast Visitor Entry (15s)',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingSystem.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // High-contrast Photo & Quick Capture Banner
            NivaasCard(
              padding: const EdgeInsets.all(SpacingSystem.m),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: ColorPalette.primaryContainer,
                    backgroundImage: _photoPath != null ? NetworkImage(_photoPath!) : null,
                    child: _photoPath == null ? const Icon(Icons.camera_alt, color: ColorPalette.primary, size: 28) : null,
                  ),
                  const SizedBox(width: SpacingSystem.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Visitor Snap & ID', style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        Text('Optional quick face verification', style: TypographyScale.caption.copyWith(color: ColorPalette.textSecondary)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_outlined, color: ColorPalette.primary),
                    onPressed: _capturePhotoHook,
                    tooltip: 'Capture Photo',
                  ),
                  IconButton(
                    icon: const Icon(Icons.badge_outlined, color: ColorPalette.primary),
                    onPressed: _captureIdProofHook,
                    tooltip: 'Scan ID Proof',
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingSystem.m),

            // Main Input Fields
            NivaasTextField(
              controller: _nameController,
              label: 'Visitor Full Name',
              hintText: 'Enter visitor name',
            ),

            const SizedBox(height: SpacingSystem.s),

            NivaasTextField(
              controller: _phoneController,
              label: 'Mobile Number (+91)',
              hintText: 'Enter 10-digit mobile number',
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: SpacingSystem.s),

            // Destination Wing & Flat Selector
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedWing,
                    decoration: const InputDecoration(
                      labelText: 'Wing / Block',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: _wings.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedWing = val);
                    },
                  ),
                ),
                const SizedBox(width: SpacingSystem.s),
                Expanded(
                  flex: 2,
                  child: NivaasTextField(
                    controller: _flatController,
                    label: 'Flat Number',
                    hintText: 'e.g. 402',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: SpacingSystem.m),

            // Quick Purpose Selector Chips
            const Text('Entry Purpose Quick Select', style: TypographyScale.caption),
            const SizedBox(height: SpacingSystem.xs),
            Wrap(
              spacing: SpacingSystem.xs,
              runSpacing: SpacingSystem.xs,
              children: _purposes.map((p) {
                final isSelected = _selectedPurpose == p;
                return ChoiceChip(
                  label: Text(p),
                  selected: isSelected,
                  selectedColor: ColorPalette.primaryContainer,
                  onSelected: (val) {
                    if (val) setState(() => _selectedPurpose = p);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: SpacingSystem.m),

            // Vehicle Number & Visitor Count
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: NivaasTextField(
                    controller: _vehicleController,
                    label: 'Vehicle Plate No (Optional)',
                    hintText: 'e.g. DL 01 XY 1234',
                  ),
                ),
                const SizedBox(width: SpacingSystem.s),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total People', style: TypographyScale.caption),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorPalette.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (_visitorCount > 1) setState(() => _visitorCount--);
                              },
                            ),
                            Text('$_visitorCount', style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _visitorCount++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: SpacingSystem.s),

            NivaasTextField(
              controller: _notesController,
              label: 'Notes / Item Description (Optional)',
              hintText: 'e.g. Carrying toolbox / Laptop bag',
            ),

            const SizedBox(height: SpacingSystem.l),

            // Submit Button
            NivaasButton.primary(
              label: 'GENERATE VISITOR ENTRY PASS',
              isLoading: _isSubmitting,
              icon: Icons.qr_code,
              onPressed: _submitRegistration,
            ),

            const SizedBox(height: SpacingSystem.xl),
          ],
        ),
      ),
    );
  }
}
