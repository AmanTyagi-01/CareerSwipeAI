import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Forgot Password Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/forgot_password_account_recovery`
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _dispatchRecovery() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.resetPassword(email);
      if (mounted) {
        context.push('/auth/recovery-confirmation', extra: email);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
              style: EditorialTypography.bodySm(color: Colors.white),
            ),
            backgroundColor: EditorialColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
                borderRadius: EditorialRadii.roundedMd),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? EditorialColors.darkBackground
        : EditorialColors.paperBackground;
    final surfaceColor =
        isDark ? EditorialColors.darkSurface : EditorialColors.paperSurface;
    final hairlineColor =
        isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline;
    final textPrimary = isDark
        ? EditorialColors.darkTextPrimary
        : EditorialColors.paperTextPrimary;
    final textSecondary =
        isDark ? EditorialColors.darkTextSecondary : EditorialColors.secondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary, size: 22.0),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/auth/login');
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'CareerSwipe AI',
          style: EditorialTypography.headlineSm(color: textPrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: EditorialSpacing.margin),
            child: Row(
              children: [
                Icon(Icons.lock_outline, size: 14.0, color: textSecondary),
                const SizedBox(width: 4.0),
                Text(
                  '256-bit TLS',
                  style: EditorialTypography.labelMd(color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: EditorialSpacing.margin,
              vertical: EditorialSpacing.spaceSm,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security metadata pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isDark
                            ? EditorialColors.darkContainerLow
                            : EditorialColors.paperContainerLow,
                        borderRadius: EditorialRadii.roundedSm,
                        border: Border.all(color: hairlineColor, width: 1.0),
                      ),
                      child: Text(
                        'ACCOUNT RECOVERY · SEC-ID 09//59',
                        style: EditorialTypography.labelStamp(
                            color: textSecondary),
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Editorial Typography Heading
                    Text(
                      'Reset master dossier password.',
                      style: EditorialTypography.headlineXlMobile(
                          color: textPrimary),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceXs),
                    Text(
                      'Enter the verified corporate or institutional email associated with your CareerSwipe dossier to initiate cryptographic recovery.',
                      style: EditorialTypography.bodyMd(color: textSecondary),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Zero-Trust Protocol Callout
                    Container(
                      padding: const EdgeInsets.all(EditorialSpacing.spaceMd),
                      decoration: BoxDecoration(
                        color: isDark
                            ? EditorialColors.darkContainerLow
                            : EditorialColors.paperContainerLow,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: hairlineColor, width: 1.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28.0,
                            height: 28.0,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: EditorialRadii.roundedSm,
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              size: 16.0,
                              color: EditorialColors.primary,
                            ),
                          ),
                          const SizedBox(width: EditorialSpacing.spaceSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NON-ENUMERATING RECOVERY PROTOCOL',
                                  style: EditorialTypography.labelStamp(
                                      color: EditorialColors.primary),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'In compliance with zero-trust standards, recovery signals are transmitted without revealing whether an active ledger account exists for this address.',
                                  style: EditorialTypography.bodySm(
                                      color: textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Email Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WORK OR UNIVERSITY EMAIL',
                          style: EditorialTypography.labelStamp(
                              color: textSecondary),
                        ),
                        Text(
                          'Required',
                          style:
                              EditorialTypography.bodySm(color: textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    EditorialTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'your.name@institution.org',
                      prefixIcon: Icon(Icons.alternate_email,
                          size: 18.0, color: textSecondary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.domain, size: 13.0, color: textSecondary),
                        const SizedBox(width: 4.0),
                        Text(
                          'Domain-validated institutional address',
                          style:
                              EditorialTypography.bodySm(color: textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Dispatch Button
                    EditorialButton(
                      label: 'Dispatch Recovery Token',
                      isLoading: _isLoading,
                      trailingIcon: const Icon(Icons.arrow_forward,
                          size: 18.0, color: Colors.white),
                      onPressed: _dispatchRecovery,
                    ),
                    const SizedBox(height: EditorialSpacing.spaceXl),

                    // Alternative Cryptographic Channel Card
                    Container(
                      padding: const EdgeInsets.all(EditorialSpacing.spaceMd),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: hairlineColor, width: 1.0),
                        boxShadow: isDark
                            ? EditorialElevation.paperCardDark
                            : EditorialElevation.paperCard,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? EditorialColors.darkContainerMid
                                  : EditorialColors.paperContainerLow,
                              borderRadius: EditorialRadii.roundedSm,
                            ),
                            child: const Icon(Icons.vpn_key_outlined,
                                size: 18.0, color: EditorialColors.primary),
                          ),
                          const SizedBox(width: EditorialSpacing.spaceSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Have your Master Dossier Recovery Key?',
                                  style: EditorialTypography.headlineSm(
                                      color: textPrimary),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Use your 24-word cryptographic seed phrase or WebAuthn physical security key to reset immediately without email access.',
                                  style: EditorialTypography.bodySm(
                                      color: textSecondary),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Use Hardware Key or Seed',
                                  style: EditorialTypography.labelMd(
                                    color: EditorialColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
