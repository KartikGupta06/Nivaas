import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_card.dart';
import '../../../../shared/widgets/cards/nivaas_clickable_card.dart';
import '../../../../shared/widgets/inputs/nivaas_text_field.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';
import '../providers/visitor_providers.dart';

/// Rapid Delivery Entry Screen for Swiggy, Zomato, Amazon, Flipkart, Blinkit, BigBasket, etc.
class DeliveryEntryScreen extends ConsumerStatefulWidget {
  const DeliveryEntryScreen({super.key});

  @override
  ConsumerState<DeliveryEntryScreen> createState() => _DeliveryEntryScreenState();
}

class _DeliveryEntryScreenState extends ConsumerState<DeliveryEntryScreen> {
  final _flatController = TextEditingController(text: '402');
  final _personNameController = TextEditingController(text: 'Delivery Partner');
  final _phoneController = TextEditingController();

  String _selectedVendor = 'SWIGGY';
  String _selectedWing = 'Wing A';
  bool _isSubmitting = false;

  final List<({String key, String label, IconData icon, Color color})> _vendors = [
    (key: 'SWIGGY', label: 'Swiggy Food', icon: Icons.fastfood, color: Colors.orange),
    (key: 'ZOMATO', label: 'Zomato', icon: Icons.restaurant, color: Colors.red),
    (key: 'AMAZON', label: 'Amazon', icon: Icons.shopping_bag, color: Colors.amber.shade700),
    (key: 'FLIPKART', label: 'Flipkart', icon: Icons.local_mall, color: Colors.blue),
    (key: 'BLINKIT', label: 'Blinkit', icon: Icons.flash_on, color: Colors.green),
    (key: 'BIGBASKET', label: 'BigBasket', icon: Icons.shopping_cart, color: Colors.lightGreen.shade700),
    (key: 'COURIER', label: 'Courier / Post', icon: Icons.markunread_mailbox, color: Colors.purple),
    (key: 'MILK', label: 'Milk / Water', icon: Icons.water_drop, color: Colors.lightBlue),
    (key: 'GAS_CYLINDER', label: 'Gas Cylinder', icon: Icons.propane_tank, color: Colors.deepOrange),
  ];

  Future<void> _submitDelivery() async {
    final flat = _flatController.text.trim();
    if (flat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter destination flat number.'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final delivery = await ref.read(deliveryNotifierProvider.notifier).registerDelivery(
      vendor: _selectedVendor,
      flatNumber: flat,
      wingName: _selectedWing,
      deliveryPersonName: _personNameController.text.trim().isEmpty ? 'Delivery Partner' : _personNameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : '+91 ${_phoneController.text.trim()}',
    );

    await ref.read(gateNotifierProvider.notifier).loadGateSummary();

    setState(() => _isSubmitting = false);

    if (mounted && delivery != null) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: ColorPalette.success, size: 28),
              SizedBox(width: 8),
              Text('Delivery Checked In'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vendor: ${delivery.vendor}', style: TypographyScale.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              Text('Flat: ${delivery.wingName} - Flat ${delivery.flatNumber}', style: TypographyScale.bodyMedium),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpacingSystem.m),
                decoration: BoxDecoration(
                  color: ColorPalette.successContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text('DELIVERY PASS CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ColorPalette.success)),
                    const SizedBox(height: 4),
                    Text(
                      delivery.passCode,
                      style: TypographyScale.headingLarge.copyWith(color: ColorPalette.success, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    const Text('Resident auto-notified!', style: TextStyle(fontSize: 11, color: ColorPalette.textSecondary)),
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
        title: 'Rapid Delivery Entry',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingSystem.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor Selection Grid
            const Text('Select Delivery Vendor (1-Tap)', style: TypographyScale.headingSmall),
            const SizedBox(height: SpacingSystem.s),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _vendors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: SpacingSystem.s,
                crossAxisSpacing: SpacingSystem.s,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final v = _vendors[index];
                final isSelected = _selectedVendor == v.key;
                return NivaasClickableCard(
                  onTap: () => setState(() => _selectedVendor = v.key),
                  padding: const EdgeInsets.all(SpacingSystem.xs),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? v.color.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(color: v.color, width: 2) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(v.icon, color: v.color, size: 28.0),
                        const SizedBox(height: 4),
                        Text(
                          v.label,
                          style: TypographyScale.caption.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? v.color : ColorPalette.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: SpacingSystem.l),

            // Destination Flat & Details
            NivaasCard(
              padding: const EdgeInsets.all(SpacingSystem.m),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedWing,
                          decoration: const InputDecoration(
                            labelText: 'Wing',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          items: ['Wing A', 'Wing B', 'Wing C'].map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
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
                          label: 'Flat No',
                          hintText: 'e.g. 402',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingSystem.s),
                  NivaasTextField(
                    controller: _personNameController,
                    label: 'Delivery Agent Name (Optional)',
                    hintText: 'e.g. Ramesh',
                  ),
                  const SizedBox(height: SpacingSystem.s),
                  NivaasTextField(
                    controller: _phoneController,
                    label: 'Agent Phone (Optional)',
                    hintText: '10-digit phone',
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingSystem.l),

            NivaasButton.primary(
              label: 'CHECK IN DELIVERY PARTNER',
              icon: Icons.local_shipping,
              isLoading: _isSubmitting,
              onPressed: _submitDelivery,
            ),
          ],
        ),
      ),
    );
  }
}
