import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Candidate Registration Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/candidate_registration_careerswipe_ai`
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  String _selectedDomain = 'Systems & Backend Engineering';

  final List<String> _domains = [
    'Systems & Backend Engineering',
    'Distributed Systems',
    'ML Infrastructure',
    'Site Reliability',
    'Frontend Core',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please verify agreement to the verified ledger terms.',
            style: EditorialTypography.bodySm(color: Colors.white),
          ),
          backgroundColor: EditorialColors.alertUrgent,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: EditorialRadii.roundedMd),
        ),
      );
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
      userType: UserType.talent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? EditorialColors.darkBackground : EditorialColors.paperBackground;
    final surfaceColor = isDark ? EditorialColors.darkSurface : EditorialColors.paperSurface;
    final hairlineColor = isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline;
    final textPrimary = isDark ? EditorialColors.darkTextPrimary : EditorialColors.paperTextPrimary;
    final textSecondary = isDark ? EditorialColors.darkTextSecondary : EditorialColors.secondary;

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            // After registration, go to candidate onboarding flow
            context.go('/auth/candidate-onboarding');
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
                style: EditorialTypography.bodySm(color: Colors.white),
              ),
              backgroundColor: EditorialColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: const RoundedRectangleBorder(borderRadius: EditorialRadii.roundedMd),
            ),
          );
        },
      );
    });

    final password = _passwordController.text;
    final hasMinLength = password.length >= 8;
    final hasMixedCase = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password);
    final hasNumberSymbol = RegExp(r'(?=.*[0-9!@#\$&*~])').hasMatch(password);

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
                    // Top Protocol Metadata
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: isDark ? EditorialColors.darkContainerLow : EditorialColors.paperContainerLow,
                        borderRadius: EditorialRadii.roundedSm,
                        border: Border.all(color: hairlineColor, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6.0,
                                height: 6.0,
                                decoration: const BoxDecoration(
                                  color: EditorialColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'ZERO-SYNTHETIC PROTOCOL',
                                style: EditorialTypography.labelStamp(color: textSecondary),
                              ),
                            ],
                          ),
                          Text(
                            'TIER-1 ARCHIVAL DOSSIER',
                            style: EditorialTypography.labelStamp(color: EditorialColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Editorial Header
                    Text(
                      'Establish your candidate dossier.',
                      style: EditorialTypography.headlineXlMobile(color: textPrimary),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceXs),
                    Text(
                      'Direct cryptographic verification. No unverified third-party recruiters. Transparent compensation bands upfront.',
                      style: EditorialTypography.bodyMd(color: textSecondary),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Candidate Legal Name
                    Text(
                      'CANDIDATE LEGAL NAME',
                      style: EditorialTypography.labelStamp(color: textSecondary),
                    ),
                    const SizedBox(height: 6.0),
                    EditorialTextField(
                      controller: _nameController,
                      hintText: 'First and last name',
                      prefixIcon: Icon(Icons.person_outline, size: 18.0, color: textSecondary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Work or University Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'INSTITUTIONAL OR WORK DOMAIN',
                          style: EditorialTypography.labelStamp(color: textSecondary),
                        ),
                        Text(
                          'Domain Validated',
                          style: EditorialTypography.bodySm(
                            color: EditorialColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    EditorialTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'alex.vance@alumni.tcd.ie',
                      prefixIcon: Icon(Icons.alternate_email, size: 18.0, color: textSecondary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid domain address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'We verify institutional and corporate domains for tier-1 verified credential badges.',
                      style: EditorialTypography.bodySm(color: textSecondary),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Primary Technical Domain Chips
                    Text(
                      'PRIMARY TECHNICAL DOMAIN',
                      style: EditorialTypography.labelStamp(color: textSecondary),
                    ),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _domains.map((domain) {
                        final isSelected = _selectedDomain == domain;
                        return EditorialChip(
                          label: domain,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedDomain = domain),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Master Password
                    Text(
                      'DOSSIER MASTER PASSWORD',
                      style: EditorialTypography.labelStamp(color: textSecondary),
                    ),
                    const SizedBox(height: 6.0),
                    EditorialTextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      hintText: 'Minimum 8 characters with mixed symbols',
                      prefixIcon: Icon(Icons.lock_outline, size: 18.0, color: textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 18.0,
                          color: textSecondary,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: EditorialSpacing.spaceSm),

                    // Password Security Ledger Card
                    Container(
                      padding: const EdgeInsets.all(EditorialSpacing.spaceSm),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: EditorialRadii.roundedMd,
                        border: Border.all(color: hairlineColor, width: 1.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ENTROPY ANALYSIS',
                                style: EditorialTypography.labelStamp(color: textSecondary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: isDark ? EditorialColors.darkContainerMid : EditorialColors.primaryLight,
                                  borderRadius: EditorialRadii.roundedSm,
                                ),
                                child: Text(
                                  hasMinLength && hasMixedCase && hasNumberSymbol
                                      ? 'CRYPTOGRAPHICALLY STRONG'
                                      : 'ENTER CRITERIA',
                                  style: EditorialTypography.labelStamp(
                                    color: isDark ? EditorialColors.onPrimaryContainer : EditorialColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    color: hasMinLength ? EditorialColors.primary : hairlineColor,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Container(
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    color: hasMixedCase ? EditorialColors.primary : hairlineColor,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Container(
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    color: hasNumberSymbol ? EditorialColors.primary : hairlineColor,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          _buildSecurityCheck(
                            'Minimum 8 characters',
                            hasMinLength,
                            textPrimary,
                            textSecondary,
                          ),
                          _buildSecurityCheck(
                            'Mixed case characters',
                            hasMixedCase,
                            textPrimary,
                            textSecondary,
                          ),
                          _buildSecurityCheck(
                            'Numeric or symbolic components',
                            hasNumberSymbol,
                            textPrimary,
                            textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Verification Consents Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: Checkbox(
                            value: _agreeToTerms,
                            activeColor: EditorialColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                            onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'I consent to cryptographic dossier verification and agree to the Terms of Service & Privacy Protocol.',
                            style: EditorialTypography.bodySm(color: textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Primary CTA
                    EditorialButton(
                      label: 'Initialize Verified Dossier',
                      isLoading: isLoading,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18.0, color: Colors.white),
                      onPressed: _signUp,
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Footer Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already registered? ',
                            style: EditorialTypography.bodyMd(color: textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/auth/login'),
                            child: Text(
                              'Sign in to existing dossier',
                              style: EditorialTypography.labelMd(
                                color: EditorialColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
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

  Widget _buildSecurityCheck(
    String label,
    bool isMet,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 14.0,
            color: isMet ? EditorialColors.primary : textSecondary,
          ),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: EditorialTypography.bodySm(
              color: isMet ? textPrimary : textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
