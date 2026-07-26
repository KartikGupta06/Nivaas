import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/routes/route_names.dart';
import '../../../../app/config/theme/color_palette.dart';
import '../../../../app/config/theme/spacing_system.dart';
import '../../../../app/config/theme/typography_scale.dart';
import '../../../../app/providers/app_config_provider.dart';
import '../../../../app/providers/auth_state_provider.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/widgets/buttons/nivaas_button.dart';
import '../../../../shared/widgets/cards/nivaas_info_card.dart';
import '../../../../shared/widgets/inputs/nivaas_password_field.dart';
import '../../../../shared/widgets/inputs/nivaas_phone_field.dart';
import '../../../../shared/widgets/layout/nivaas_gap.dart';
import '../../../../shared/widgets/navigation/nivaas_app_bar.dart';

import '../providers/auth_controller.dart';

/// Clean, Accessible Mobile-First Login Screen strictly adhering to DESIGN_SYSTEM.md.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '9876543210');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final authController = ref.read(authControllerProvider);
    final success = await authController.loginWithPhone(phone, password);

    if (success && mounted) {
      final authState = ref.read(authStateProvider);
      _navigateForRole(authState.userRole);
    }
  }

  void _navigateForRole(UserRole role) {
    switch (role) {
      case UserRole.societyAdmin:
        context.go(RouteNames.adminHome);
        break;
      case UserRole.watchman:
        context.go(RouteNames.watchmanHome);
        break;
      case UserRole.resident:
      default:
        context.go(RouteNames.residentHome);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final appConfig = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: const NivaasAppBar(
        title: 'Sign In',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SpacingSystem.m),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome to Nivaas',
                        style: TypographyScale.headingLarge,
                      ),
                      const SizedBox(height: SpacingSystem.xs),
                      const Text(
                        'Enter your registered mobile number to continue.',
                        style: TypographyScale.bodyMedium,
                      ),
                      const NivaasGap.l(),
                      if (authState.errorMessage != null) ...[
                        NivaasInfoCard.error(
                          title: 'Authentication Failed',
                          subtitle: authState.errorMessage,
                        ),
                        const NivaasGap.m(),
                      ],
                      NivaasPhoneField(
                        controller: _phoneController,
                        enabled: !authState.isLoading,
                      ),
                      const NivaasGap.m(),
                      NivaasPasswordField(
                        controller: _passwordController,
                        errorText: null,
                      ),
                      const NivaasGap.l(),
                      NivaasButton.primary(
                        label: 'Sign In',
                        isLoading: authState.isLoading,
                        onPressed: _handleLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Developer-Only Quick Role Switcher Bar in Development Mode
            if (appConfig.isDevelopment)
              Container(
                color: ColorPalette.primaryContainer,
                padding: const EdgeInsets.all(SpacingSystem.s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🛠️ DEV MOCK ROLE SWITCHER',
                      style: TypographyScale.caption.copyWith(
                        color: ColorPalette.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDevRoleButton(UserRole.resident, 'Resident'),
                        _buildDevRoleButton(UserRole.societyAdmin, 'Admin'),
                        _buildDevRoleButton(UserRole.watchman, 'Watchman'),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevRoleButton(UserRole role, String label) {
    return InkWell(
      onTap: () async {
        final authController = ref.read(authControllerProvider);
        await authController.debugSwitchRole(role);
        if (mounted) _navigateForRole(role);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: ColorPalette.surface,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: ColorPalette.primary),
        ),
        child: Text(
          label,
          style: TypographyScale.caption.copyWith(
            color: ColorPalette.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
