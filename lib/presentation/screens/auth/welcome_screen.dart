import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/editorial/editorial.dart';

/// Welcome Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/welcome_careerswipe_ai`
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? EditorialColors.darkBackground : EditorialColors.paperBackground;
    final surfaceColor = isDark ? EditorialColors.darkSurface : EditorialColors.paperSurface;
    final hairlineColor = isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline;
    final textPrimary = isDark ? EditorialColors.darkTextPrimary : EditorialColors.paperTextPrimary;
    final textSecondary = isDark ? EditorialColors.darkTextSecondary : EditorialColors.secondary;

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
              backgroundColor: isDark ? EditorialColors.darkContainerMid : EditorialColors.primaryLight,
              child: Icon(
                Icons.person_outline,
                size: 18.0,
                color: isDark ? EditorialColors.onPrimaryContainer : EditorialColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: EditorialSpacing.margin,
            vertical: EditorialSpacing.spaceSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Meta / Platform Stamp
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: EditorialColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: EditorialSpacing.spaceXs),
                      Text(
                        'PROTOCOL V2.4',
                        style: EditorialTypography.labelStamp(color: textSecondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: isDark ? EditorialColors.darkContainerMid : EditorialColors.paperContainerLow,
                      borderRadius: EditorialRadii.roundedSm,
                      border: Border.all(color: hairlineColor, width: 1.0),
                    ),
                    child: Text(
                      'VERIFIED SIGNAL PLATFORM',
                      style: EditorialTypography.labelStamp(color: textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EditorialSpacing.spaceMd),

              // Editorial Hero Section
              Row(
                children: [
                  const Icon(
                    Icons.verified,
                    size: 18.0,
                    color: EditorialColors.primary,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'Curated Career Dispatch',
                    style: EditorialTypography.labelMd(
                      color: EditorialColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),
              Text(
                'Where engineering talent meets verified opportunity.',
                style: EditorialTypography.headlineXlMobile(color: textPrimary),
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),
              Text(
                'No synthetic match algorithms. No black-box rejection funnels. Swipe through evidence-backed roles cross-referenced against your actual technical artifacts.',
                style: EditorialTypography.bodyMd(color: textSecondary),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Visual Proof Strip: Live Dispatch Metric
              Container(
                padding: const EdgeInsets.all(EditorialSpacing.spaceSm + 2.0),
                decoration: BoxDecoration(
                  color: isDark ? EditorialColors.darkContainerLow : EditorialColors.paperContainerLow,
                  borderRadius: EditorialRadii.roundedMd,
                  border: Border.all(color: hairlineColor, width: 1.0),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16.0,
                      backgroundColor: EditorialColors.primary,
                      child: Icon(Icons.sync_alt, size: 16.0, color: Colors.white),
                    ),
                    const SizedBox(width: EditorialSpacing.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LIVE DISPATCH QUEUE',
                            style: EditorialTypography.labelStamp(color: textSecondary),
                          ),
                          Text(
                            '842 verified engineering mandates',
                            style: EditorialTypography.labelLg(color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isDark ? EditorialColors.darkContainerMid : const Color(0xFFE2E2E2),
                        borderRadius: EditorialRadii.roundedSm,
                      ),
                      child: Text(
                        '99.4% SIGNAL',
                        style: EditorialTypography.labelStamp(color: EditorialColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // 3 Tenets of Verified Matching
              Text(
                'THE THREE TENETS OF VERIFIED MATCHING',
                style: EditorialTypography.labelStamp(color: textSecondary),
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),

              _buildPillarCard(
                context,
                step: '01',
                icon: Icons.terminal,
                title: 'Cryptographic Ledger Match',
                description:
                    'Cross-matches your repository citations and architecture work against strict engineering specs.',
                surfaceColor: surfaceColor,
                hairlineColor: hairlineColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                isDark: isDark,
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),

              _buildPillarCard(
                context,
                step: '02',
                icon: Icons.payments_outlined,
                title: 'Transparent Compensation',
                description:
                    'Every listing requires verified base salary ranges and equity disclosure upfront. No ambiguous brackets.',
                surfaceColor: surfaceColor,
                hairlineColor: hairlineColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                isDark: isDark,
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),

              _buildPillarCard(
                context,
                step: '03',
                icon: Icons.outgoing_mail,
                title: 'Direct Recruiter Dispatch',
                description:
                    'Skip the ATS void. Right-swiped endorsements route your technical dossier directly to hiring leadership.',
                surfaceColor: surfaceColor,
                hairlineColor: hairlineColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                isDark: isDark,
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Sample Audited Role Card
              Container(
                padding: const EdgeInsets.all(EditorialSpacing.spaceMd),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: EditorialRadii.roundedMd,
                  border: Border.all(color: hairlineColor, width: 1.0),
                  boxShadow: isDark ? EditorialElevation.paperCardDark : EditorialElevation.paperCard,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SENIOR DISTRIBUTED SYSTEMS ENGINEER',
                          style: EditorialTypography.labelStamp(color: textSecondary),
                        ),
                        Text(
                          '\$240k – \$280k',
                          style: EditorialTypography.labelLg(color: textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Vanguard Telemetry · Remote / NYC',
                      style: EditorialTypography.bodySm(color: textSecondary),
                    ),
                    const SizedBox(height: EditorialSpacing.spaceSm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: isDark ? EditorialColors.darkContainerLow : EditorialColors.paperContainerLow,
                        borderRadius: EditorialRadii.roundedSm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.fact_check_outlined,
                                size: 16.0,
                                color: EditorialColors.primary,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'Verified against: github.com/telemetry-raft-node',
                                style: EditorialTypography.bodySm(color: textPrimary),
                              ),
                            ],
                          ),
                          Text(
                            'AUDITED',
                            style: EditorialTypography.labelStamp(color: EditorialColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Actions CTA Area
              EditorialButton(
                label: 'Create Verified Account',
                trailingIcon: const Icon(Icons.arrow_forward, size: 18.0, color: Colors.white),
                onPressed: () => context.push('/auth/role-selection'),
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),
              EditorialButton(
                label: 'Sign In to Existing Dossier',
                variant: EditorialButtonVariant.secondary,
                leadingIcon: const Icon(Icons.fingerprint, size: 18.0),
                onPressed: () => context.push('/auth/login'),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Footer Disclaimer
              Center(
                child: Text(
                  'Protected by ledger verification · Zero automated ghosting',
                  style: EditorialTypography.bodySm(color: textSecondary),
                ),
              ),
              const SizedBox(height: EditorialSpacing.spaceSm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarCard(
    BuildContext context, {
    required String step,
    required IconData icon,
    required String title,
    required String description,
    required Color surfaceColor,
    required Color hairlineColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(EditorialSpacing.spaceMd),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: hairlineColor, width: 1.0),
        boxShadow: isDark ? EditorialElevation.paperCardDark : EditorialElevation.paperCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: isDark ? EditorialColors.darkContainerMid : EditorialColors.paperContainerLow,
                      borderRadius: EditorialRadii.roundedSm,
                    ),
                    child: Icon(icon, size: 16.0, color: EditorialColors.primary),
                  ),
                  const SizedBox(width: EditorialSpacing.spaceSm),
                  Text(
                    title,
                    style: EditorialTypography.labelLg(color: textPrimary),
                  ),
                ],
              ),
              Text(
                step,
                style: EditorialTypography.labelStamp(color: textSecondary),
              ),
            ],
          ),
          const SizedBox(height: EditorialSpacing.spaceSm),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              description,
              style: EditorialTypography.bodyMd(color: textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
