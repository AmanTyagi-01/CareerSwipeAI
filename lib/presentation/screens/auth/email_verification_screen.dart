import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Email Verification Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/email_verification_security_token`
class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyToken() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the full 6-digit confirmation token.',
            style: EditorialTypography.bodySm(color: Colors.white),
          ),
          backgroundColor: EditorialColors.alertUrgent,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: EditorialRadii.roundedMd),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.verifyOTP(code);
      if (mounted) {
        context.go('/home');
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

  Future<void> _resendToken() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendOTP(
          widget.email.isNotEmpty ? widget.email : 'alex.vance@alumni.tcd.ie');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'A fresh 6-digit confirmation token has been dispatched.',
              style: EditorialTypography.bodySm(color: Colors.white),
            ),
            backgroundColor: EditorialColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
                borderRadius: EditorialRadii.roundedMd),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to resend token: $e',
              style: EditorialTypography.bodySm(color: Colors.white),
            ),
            backgroundColor: EditorialColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
                borderRadius: EditorialRadii.roundedMd),
          ),
        );
      }
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

    final displayEmail =
        widget.email.isNotEmpty ? widget.email : 'alex.vance@alumni.tcd.ie';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Security Dossier Metadata Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              'SECURITY DOSSIER · SEC-ID 08//59',
                              style: EditorialTypography.labelStamp(
                                  color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.verified_user,
                              size: 14.0, color: EditorialColors.primary),
                          const SizedBox(width: 4.0),
                          Text(
                            'SSL Encrypted',
                            style: EditorialTypography.labelMd(
                                color: textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: EditorialSpacing.spaceMd),

                  // Editorial Headline
                  Text(
                    'Verify your email identity.',
                    style: EditorialTypography.headlineXlMobile(
                        color: textPrimary),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceXs),
                  Text(
                    'We have dispatched a cryptographic 6-digit confirmation token to your institutional domain.',
                    style: EditorialTypography.bodyMd(color: textSecondary),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceLg),

                  // Destination Email Module
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TARGET DISPATCH ADDRESS',
                              style: EditorialTypography.labelStamp(
                                  color: textSecondary),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/auth/signup');
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Edit',
                                    style: EditorialTypography.labelMd(
                                      color: EditorialColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 2.0),
                                  const Icon(Icons.edit,
                                      size: 13.0,
                                      color: EditorialColors.primary),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: EditorialSpacing.spaceSm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayEmail,
                                  style: EditorialTypography.headlineSm(
                                      color: textPrimary),
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.account_balance_outlined,
                                      size: 14.0,
                                      color: EditorialColors.primary,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      'Institutional Network · Validated Domain',
                                      style: EditorialTypography.bodySm(
                                          color: textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 18.0,
                              backgroundColor: isDark
                                  ? EditorialColors.darkContainerMid
                                  : EditorialColors.paperContainerLow,
                              child: const Icon(
                                Icons.domain,
                                size: 18.0,
                                color: EditorialColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceLg),

                  // Confirmation Token Label
                  Text(
                    'CONFIRMATION TOKEN (6 DIGITS)',
                    style: EditorialTypography.labelStamp(color: textSecondary),
                  ),
                  const SizedBox(height: 8.0),

                  // Monospace 6-Digit Code Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 48.0,
                        height: 54.0,
                        child: TextFormField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style:
                              EditorialTypography.headlineLg(color: textPrimary)
                                  .copyWith(
                            fontFamily: 'JetBrains Mono',
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: surfaceColor,
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: EditorialRadii.roundedMd,
                              borderSide:
                                  BorderSide(color: hairlineColor, width: 1.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: EditorialRadii.roundedMd,
                              borderSide: BorderSide(
                                  color: EditorialColors.primary, width: 1.5),
                            ),
                          ),
                          onChanged: (val) => _onDigitChanged(i, val),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceSm),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Press TAB or auto-advance on paste',
                        style: EditorialTypography.bodySm(color: textSecondary),
                      ),
                      GestureDetector(
                        onTap: _resendToken,
                        child: Text(
                          'Resend token',
                          style: EditorialTypography.labelMd(
                            color: EditorialColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: EditorialSpacing.spaceXl),

                  // Primary CTA
                  EditorialButton(
                    label: 'Verify Token & Unlock Dossier',
                    isLoading: _isLoading,
                    trailingIcon: const Icon(Icons.arrow_forward,
                        size: 18.0, color: Colors.white),
                    onPressed: _verifyToken,
                  ),
                  const SizedBox(height: EditorialSpacing.spaceLg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
