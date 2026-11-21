import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Candidate Login Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/sign_in_candidate_dossier`
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberDevice = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  Future<void> _loginWithGoogle() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
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

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            context.go('/home');
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
              shape: const RoundedRectangleBorder(
                  borderRadius: EditorialRadii.roundedMd),
            ),
          );
        },
      );
    });

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
              context.go('/onboarding');
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
            child: CircleAvatar(
              radius: 16.0,
              backgroundColor: isDark
                  ? EditorialColors.darkContainerMid
                  : EditorialColors.primaryLight,
              child: Icon(
                Icons.person_outline,
                size: 18.0,
                color: isDark
                    ? EditorialColors.onPrimaryContainer
                    : EditorialColors.primary,
              ),
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
                    // Dossier Telemetry Card
                    Container(
                      padding: const EdgeInsets.all(EditorialSpacing.spaceSm),
                      decoration: BoxDecoration(
                        color: isDark
                            ? EditorialColors.darkContainerLow
                            : EditorialColors.paperContainerLow,
                        borderRadius: EditorialRadii.roundedMd,
                        border: Border.all(color: hairlineColor, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ACTIVE DISPATCHES',
                                  style: EditorialTypography.labelStamp(
                                      color: textSecondary),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  '14 Roles',
                                  style: EditorialTypography.labelLg(
                                      color: EditorialColors.primary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 1.0, height: 28.0, color: hairlineColor),
                          const SizedBox(width: EditorialSpacing.spaceSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MEDIAN FIT',
                                  style: EditorialTypography.labelStamp(
                                      color: textSecondary),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  '94.2%',
                                  style: EditorialTypography.labelLg(
                                      color: EditorialColors.primary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 1.0, height: 28.0, color: hairlineColor),
                          const SizedBox(width: EditorialSpacing.spaceSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VERIFIED FIRMS',
                                  style: EditorialTypography.labelStamp(
                                      color: textSecondary),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  'Tier 1 & Labs',
                                  style: EditorialTypography.labelLg(
                                      color: EditorialColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Quick OAuth Option (Google Workspace)
                    OutlinedButton(
                      onPressed: isLoading ? null : _loginWithGoogle,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: surfaceColor,
                        side: BorderSide(color: hairlineColor, width: 1.0),
                        shape: const RoundedRectangleBorder(
                            borderRadius: EditorialRadii.roundedMd),
                        minimumSize: const Size(double.infinity, 48.0),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            'https://www.gstatic.com/images/branding/product/1x/gsa_512dp.png',
                            width: 18.0,
                            height: 18.0,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.account_circle,
                              size: 18.0,
                              color: EditorialColors.primary,
                            ),
                          ),
                          const SizedBox(width: EditorialSpacing.spaceSm),
                          Flexible(
                            child: Text(
                              'Continue with Google Workspace',
                              style: EditorialTypography.labelLg(
                                  color: textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child:
                                Divider(color: hairlineColor, thickness: 1.0)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'OR SIGN IN WITH WORK EMAIL',
                            style: EditorialTypography.labelStamp(
                                color: textSecondary),
                          ),
                        ),
                        Expanded(
                            child:
                                Divider(color: hairlineColor, thickness: 1.0)),
                      ],
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Email Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Work or University Email',
                          style: EditorialTypography.labelMd(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? EditorialColors.darkContainerMid
                                : EditorialColors.paperContainerLow,
                            borderRadius: EditorialRadii.roundedSm,
                          ),
                          child: Text(
                            'SSO VERIFIED',
                            style: EditorialTypography.labelStamp(
                                color: textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    EditorialTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'name@company.com',
                      prefixIcon: Icon(Icons.alternate_email,
                          size: 18.0, color: textSecondary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid work email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Master Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Master Password',
                          style: EditorialTypography.labelMd(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? EditorialColors.darkContainerMid
                                : EditorialColors.primaryLight,
                            borderRadius: EditorialRadii.roundedSm,
                          ),
                          child: Text(
                            '256-BIT ENCRYPTED',
                            style: EditorialTypography.labelStamp(
                              color: isDark
                                  ? EditorialColors.onPrimaryContainer
                                  : EditorialColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    EditorialTextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline,
                          size: 18.0, color: textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18.0,
                          color: textSecondary,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: EditorialSpacing.spaceSm),

                    // Auxiliary Row: Remember & Forgot
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: EditorialSpacing.spaceSm,
                      runSpacing: EditorialSpacing.spaceXs,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: Checkbox(
                                value: _rememberDevice,
                                activeColor: EditorialColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                onChanged: (val) => setState(
                                    () => _rememberDevice = val ?? true),
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              'Remember device (30 days)',
                              style: EditorialTypography.bodySm(
                                  color: textSecondary),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => context.push('/auth/forgot-password'),
                          child: Text(
                            'Forgot password?',
                            style: EditorialTypography.labelMd(
                              color: EditorialColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Primary Submit Button
                    EditorialButton(
                      label: 'Unlock Career Dossier',
                      isLoading: isLoading,
                      trailingIcon: const Icon(Icons.arrow_forward,
                          size: 18.0, color: Colors.white),
                      onPressed: _login,
                    ),
                    const SizedBox(height: EditorialSpacing.spaceMd),

                    // Security note
                    Center(
                      child: Text(
                        'Protected by hardware-backed enclave encryption · CareerSwipe AI Protocol',
                        textAlign: TextAlign.center,
                        style: EditorialTypography.bodySm(color: textSecondary),
                      ),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceLg),

                    // Footer Link
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Don't have a verified dossier? ",
                            style: EditorialTypography.bodyMd(
                                color: textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/auth/role-selection'),
                            child: Text(
                              'Create candidate account',
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
}
