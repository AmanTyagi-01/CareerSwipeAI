import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/editorial/editorial.dart';

/// Recovery Confirmation Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/recovery_confirmation_token_dispatched`
class RecoveryConfirmationScreen extends StatelessWidget {
  final String? email;

  const RecoveryConfirmationScreen({
    super.key,
    this.email,
  });

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

    final displayEmail = (email != null && email!.isNotEmpty)
        ? email!
        : 'alex.vance@alumni.tcd.ie';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary, size: 22.0),
          onPressed: () => context.go('/auth/login'),
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
                  // Metadata Row
                  Row(
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
                            'RECOVERY DISPATCHED · SEC-ID 10//59',
                            style: EditorialTypography.labelStamp(
                                color: textSecondary),
                          ),
                        ],
                      ),
                      Text(
                        'UTC DISPATCHED',
                        style: EditorialTypography.labelStamp(
                            color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: EditorialSpacing.spaceMd),

                  // Primary Outcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(EditorialSpacing.spaceLg),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: hairlineColor, width: 1.0),
                      boxShadow: isDark
                          ? EditorialElevation.paperCardDark
                          : EditorialElevation.paperCard,
                    ),
                    child: Column(
                      children: [
                        // Seal Icon Graphic
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 32.0,
                              backgroundColor: isDark
                                  ? EditorialColors.darkContainerMid
                                  : EditorialColors.paperContainerLow,
                              child: const Icon(
                                Icons.mark_email_read_outlined,
                                size: 32.0,
                                color: EditorialColors.primary,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: const BoxDecoration(
                                  color: EditorialColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    size: 12.0, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: EditorialSpacing.spaceMd),

                        // Editorial Serif Headline
                        Text(
                          'Recovery instructions dispatched.',
                          textAlign: TextAlign.center,
                          style: EditorialTypography.headlineXlMobile(
                              color: textPrimary),
                        ),
                        const SizedBox(height: EditorialSpacing.spaceSm),

                        // Editorial Subtext
                        Text(
                          'If an active engineering or recruiter dossier is linked to $displayEmail, a cryptographic reset token has been securely transmitted.',
                          textAlign: TextAlign.center,
                          style:
                              EditorialTypography.bodyMd(color: textSecondary),
                        ),
                        const SizedBox(height: EditorialSpacing.spaceMd),

                        // Countdown Timer Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? EditorialColors.darkContainerLow
                                : EditorialColors.paperContainerLow,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined,
                                  size: 15.0, color: EditorialColors.primary),
                              const SizedBox(width: 6.0),
                              Text(
                                'Token expires in 15:00',
                                style: EditorialTypography.labelMd(
                                  color: textPrimary,
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

                  // Dispatch Metadata Ledger
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.key,
                                    size: 15.0, color: EditorialColors.primary),
                                const SizedBox(width: 6.0),
                                Text(
                                  'DISPATCH METADATA',
                                  style: EditorialTypography.labelStamp(
                                      color: textSecondary),
                                ),
                              ],
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
                                'AUTHENTICATED',
                                style: EditorialTypography.labelStamp(
                                  color: isDark
                                      ? EditorialColors.onPrimaryContainer
                                      : EditorialColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: EditorialSpacing.spaceSm),
                        _buildMetaRow('Destination', displayEmail, textPrimary,
                            textSecondary, isDark),
                        _buildMetaRow(
                            'Security Policy',
                            'Single-use token protocol',
                            textPrimary,
                            textSecondary,
                            isDark),
                        _buildMetaRow(
                            'Token Invalidation',
                            'Revoked on initial use',
                            textPrimary,
                            textSecondary,
                            isDark),
                        _buildMetaRow('Fingerprint', 'SHA-256 · e82f...91c4',
                            textPrimary, textSecondary, isDark,
                            isCode: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceLg),

                  // Procedural Next Steps
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(EditorialSpacing.spaceMd),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: hairlineColor, width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PROCEDURAL NEXT STEPS',
                          style: EditorialTypography.labelStamp(
                              color: textSecondary),
                        ),
                        const SizedBox(height: EditorialSpacing.spaceSm),
                        _buildStepItem(
                            '1',
                            'Check your institutional inbox for the security dispatch.',
                            textPrimary,
                            textSecondary,
                            isDark),
                        _buildStepItem(
                            '2',
                            'Follow the zero-knowledge link or enter the confirmation token.',
                            textPrimary,
                            textSecondary,
                            isDark),
                        _buildStepItem(
                            '3',
                            'Set a new 256-bit encrypted master dossier password.',
                            textPrimary,
                            textSecondary,
                            isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: EditorialSpacing.spaceXl),

                  // Return CTA
                  EditorialButton(
                    label: 'Return to Sign In',
                    trailingIcon: const Icon(Icons.arrow_forward,
                        size: 18.0, color: Colors.white),
                    onPressed: () => context.go('/auth/login'),
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

  Widget _buildMetaRow(
    String label,
    String value,
    Color textPrimary,
    Color textSecondary,
    bool isDark, {
    bool isCode = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isDark
            ? EditorialColors.darkContainerLow
            : EditorialColors.paperContainerLow,
        borderRadius: EditorialRadii.roundedSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: EditorialTypography.labelMd(color: textSecondary)),
          Text(
            value,
            style: isCode
                ? EditorialTypography.telemetryCode(color: textPrimary)
                : EditorialTypography.bodySm(
                    color: textPrimary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    String number,
    String instruction,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10.0,
            backgroundColor: isDark
                ? EditorialColors.darkContainerMid
                : EditorialColors.paperContainerHigh,
            child: Text(
              number,
              style: EditorialTypography.labelStamp(color: textPrimary),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              instruction,
              style: EditorialTypography.bodySm(color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
