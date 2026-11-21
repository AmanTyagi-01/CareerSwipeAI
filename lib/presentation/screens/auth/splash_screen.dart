import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Splash Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/splash_screen_careerswipe_ai`
///
/// Features:
/// - Editorial Utility warm paper canvas (#FBFBFA / #121314)
/// - Top protocol telemetry badge ("TALENT DISPATCH PROTOCOL · VERIFIED TALENT NETWORK")
/// - Tactile geometric brand mark with physical paper elevation
/// - Newsreader headline: "CareerSwipe AI"
/// - Italic subtitle: "Where engineering talent meets verified opportunity."
/// - Quality seal: "EST. 2025"
/// - Bottom initialization ledger card with session restore checklist and progress indicator
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _hasNavigated = false;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressAnimation = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.forward();

    _navTimer = Timer(const Duration(milliseconds: 2400), _navigate);
  }

  void _navigate() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final authService = ref.read(authServiceProvider);

    if (!authService.isAuthenticated) {
      context.go('/onboarding');
      return;
    }

    // Authenticated — resolve profile to pick the right destination.
    authService.getCurrentUserData().then((userData) {
      if (!mounted) return;
      if (userData == null || !userData.isProfileComplete) {
        // New user or incomplete profile → onboarding
        final route = (userData?.userType == UserType.recruiter)
            ? '/auth/recruiter-onboarding'
            : '/auth/candidate-onboarding';
        context.go(route);
      } else if (userData.userType == UserType.recruiter) {
        context.go('/recruiter/dashboard');
      } else {
        context.go('/home');
      }
    }).catchError((_) {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _progressController.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: EditorialSpacing.margin,
            vertical: EditorialSpacing.spaceMd,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Protocol Metadata Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
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
                    const SizedBox(width: 8.0),
                    Text(
                      'TALENT DISPATCH PROTOCOL',
                      style:
                          EditorialTypography.labelStamp(color: textSecondary),
                    ),
                    const SizedBox(width: 8.0),
                    Container(width: 1.0, height: 10.0, color: hairlineColor),
                    const SizedBox(width: 8.0),
                    Text(
                      'VERIFIED TALENT NETWORK',
                      style: EditorialTypography.labelStamp(
                          color: EditorialColors.primary),
                    ),
                  ],
                ),
              ),

              // Centered Brand Mark & Editorial Typography
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tactile Brand Mark Container
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: hairlineColor, width: 1.0),
                      boxShadow: isDark
                          ? EditorialElevation.paperCardDark
                          : EditorialElevation.paperCard,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 40.0,
                            color: isDark
                                ? EditorialColors.onPrimaryContainer
                                : EditorialColors.primary,
                          ),
                          Positioned(
                            right: 4.0,
                            bottom: 4.0,
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: const BoxDecoration(
                                color: EditorialColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceLg),

                  // Editorial Headline
                  Text(
                    'CareerSwipe AI',
                    style: EditorialTypography.headlineXlMobile(
                        color: textPrimary),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceXs),
                  Text(
                    'Where engineering talent meets verified opportunity.',
                    textAlign: TextAlign.center,
                    style: EditorialTypography.headlineSm(color: textSecondary)
                        .copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceMd),

                  // Quiet Monogram Seal
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 24.0, height: 1.0, color: hairlineColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'EST. 2025',
                          style: EditorialTypography.labelStamp(
                              color: textSecondary),
                        ),
                      ),
                      Container(width: 24.0, height: 1.0, color: hairlineColor),
                    ],
                  ),
                ],
              ),

              // Bottom Initialization Ledger Card
              Container(
                width: double.infinity,
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 18.0,
                              color: EditorialColors.primary,
                            ),
                            const SizedBox(width: EditorialSpacing.spaceXs),
                            Text(
                              'Session Restore & Integrity Audit',
                              style: EditorialTypography.labelLg(
                                  color: textPrimary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: const BoxDecoration(
                            color: EditorialColors.primaryLight,
                            borderRadius: EditorialRadii.roundedSm,
                          ),
                          child: Text(
                            'LIVE',
                            style: EditorialTypography.labelStamp(
                                color: EditorialColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: EditorialSpacing.spaceSm),

                    // Audit Step 1
                    _buildAuditStep(
                      context,
                      isCompleted: true,
                      label: 'Hardware-backed TLS session valid',
                      meta: '24ms',
                      isDark: isDark,
                    ),
                    const SizedBox(height: EditorialSpacing.spaceXs),

                    // Audit Step 2
                    _buildAuditStep(
                      context,
                      isCompleted: true,
                      label: 'Local cryptographic ledger cache loaded',
                      meta: '110kb',
                      isDark: isDark,
                    ),
                    const SizedBox(height: EditorialSpacing.spaceXs),

                    // Audit Step 3 (In progress)
                    _buildAuditStep(
                      context,
                      isCompleted: false,
                      label: 'Verifying zero-synthetic token...',
                      meta: 'RUNNING',
                      isDark: isDark,
                    ),
                    const SizedBox(height: EditorialSpacing.spaceSm),

                    // Animated Progress Bar
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(999.0),
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: isDark
                                ? EditorialColors.darkContainerMid
                                : EditorialColors.paperContainerLow,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                EditorialColors.primary),
                            minHeight: 4.0,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuditStep(
    BuildContext context, {
    required bool isCompleted,
    required String label,
    required String meta,
    required bool isDark,
  }) {
    final textPrimary = isDark
        ? EditorialColors.darkTextPrimary
        : EditorialColors.paperTextPrimary;
    final textSecondary =
        isDark ? EditorialColors.darkTextSecondary : EditorialColors.secondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: isCompleted
                    ? (isDark
                        ? EditorialColors.primaryContainer
                            .withValues(alpha: 0.3)
                        : EditorialColors.primaryLight)
                    : (isDark
                        ? EditorialColors.darkContainerMid
                        : EditorialColors.paperContainerLow),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check,
                        size: 11.0, color: EditorialColors.primary)
                    : Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: const BoxDecoration(
                          color: EditorialColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: EditorialSpacing.spaceSm),
            Text(
              label,
              style: EditorialTypography.bodySm(
                color: isCompleted ? textPrimary : EditorialColors.primary,
                fontWeight: isCompleted ? FontWeight.w400 : FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          meta,
          style: isCompleted
              ? EditorialTypography.labelMd(color: textSecondary)
              : EditorialTypography.labelStamp(color: EditorialColors.primary),
        ),
      ],
    );
  }
}
