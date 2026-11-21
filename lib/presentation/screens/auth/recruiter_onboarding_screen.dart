import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Recruiter Onboarding Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/recruiter_onboarding_organization_setup`
class RecruiterOnboardingScreen extends ConsumerStatefulWidget {
  const RecruiterOnboardingScreen({super.key});

  @override
  ConsumerState<RecruiterOnboardingScreen> createState() =>
      _RecruiterOnboardingScreenState();
}

class _RecruiterOnboardingScreenState
    extends ConsumerState<RecruiterOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController(text: 'Stripe Ireland Ltd.');
  final _titleController = TextEditingController(
      text: 'Lead Technical Recruiter — Infrastructure & Systems');
  final _emailController = TextEditingController(text: 'recruiter@company.com');
  String _selectedTier = 'TIER B';

  final List<Map<String, String>> _volumeTiers = [
    {
      'tier': 'TIER A',
      'volume': '1 – 10 Hires / Year',
      'scope': 'Seed & Series A'
    },
    {
      'tier': 'TIER B',
      'volume': '11 – 50 Hires / Year',
      'scope': 'Growth & Scale-up'
    },
    {
      'tier': 'TIER C',
      'volume': '51 – 200 Hires / Year',
      'scope': 'Enterprise Division'
    },
    {
      'tier': 'TIER D',
      'volume': '200+ Hires / Year',
      'scope': 'Global Technical Org'
    },
  ];

  @override
  void dispose() {
    _companyController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final authNotifier = ref.read(authNotifierProvider.notifier);
    // 1. Persist org details
    await authNotifier.updateProfile(
      displayName: _titleController.text.trim(),
      industry: _companyController.text.trim(),
    );
    // 2. Mark profile complete + set role as recruiter
    await authNotifier.completeOnboarding(role: UserType.recruiter);
    if (mounted) {
      // Router redirect will now see isProfileComplete = true + role = recruiter
      context.go('/recruiter/dashboard');
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
              context.go('/auth/role-selection');
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'ORGANIZATION SETUP · STEP 1 OF 3',
          style: EditorialTypography.labelStamp(color: textSecondary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: EditorialSpacing.margin),
            child: Center(
              child: Text(
                'Draft Saved',
                style: EditorialTypography.labelMd(color: textSecondary),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editorial Headline
                Text(
                  'Register your hiring organization.',
                  style:
                      EditorialTypography.headlineXlMobile(color: textPrimary),
                ),
                const SizedBox(height: EditorialSpacing.spaceXs),
                Text(
                  'Connect your team to verified candidate code repositories. All postings require transparent compensation bands.',
                  style: EditorialTypography.bodyMd(color: textSecondary),
                ),
                const SizedBox(height: EditorialSpacing.spaceLg),

                // Trust Notice Card (Tonal Paper)
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
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: isDark
                              ? EditorialColors.darkContainerMid
                              : Colors.white,
                          borderRadius: EditorialRadii.roundedSm,
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          size: 18.0,
                          color: EditorialColors.primary,
                        ),
                      ),
                      const SizedBox(width: EditorialSpacing.spaceSm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? EditorialColors.primaryContainer
                                        .withValues(alpha: 0.2)
                                    : EditorialColors.primaryLight,
                                borderRadius: EditorialRadii.roundedSm,
                              ),
                              child: Text(
                                'UNVERIFIED ORG STATUS · TIER 2 REVIEW',
                                style: EditorialTypography.labelStamp(
                                    color: EditorialColors.primary),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'New recruiter profiles undergo corporate domain DNS verification and EU pay transparency compliance review before requisitions go live.',
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

                // Field 1: Corporate Domain Email
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CORPORATE DOMAIN EMAIL',
                      style:
                          EditorialTypography.labelStamp(color: textSecondary),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 14.0, color: EditorialColors.primary),
                        const SizedBox(width: 4.0),
                        Text(
                          'Domain Match Confirmed',
                          style: EditorialTypography.bodySm(
                            color: EditorialColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                EditorialTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.business_outlined,
                      size: 18.0, color: textSecondary),
                  suffixIcon: Icon(Icons.lock_outline,
                      size: 16.0, color: textSecondary),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Authenticated via Google Workspace SSO. Tied to corporate MX records.',
                  style: EditorialTypography.bodySm(color: textSecondary),
                ),
                const SizedBox(height: EditorialSpacing.spaceMd),

                // Field 2: Legal Company Entity Name
                Text(
                  'LEGAL COMPANY ENTITY NAME',
                  style: EditorialTypography.labelStamp(color: textSecondary),
                ),
                const SizedBox(height: 6.0),
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
                      TextFormField(
                        controller: _companyController,
                        style: EditorialTypography.bodyMd(color: textPrimary),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Company name is required'
                            : null,
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: isDark
                              ? EditorialColors.darkContainerLow
                              : EditorialColors.paperContainerLow,
                          borderRadius: EditorialRadii.roundedSm,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14.0, color: textSecondary),
                            const SizedBox(width: 4.0),
                            Text(
                              'Registered Hub: Dublin Hub / EMEA (IE9827341M)',
                              style: EditorialTypography.bodySm(
                                  color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: EditorialSpacing.spaceMd),

                // Field 3: Recruiter Role & Focus
                Text(
                  'HIRING ROLE & TECHNICAL SCOPE',
                  style: EditorialTypography.labelStamp(color: textSecondary),
                ),
                const SizedBox(height: 6.0),
                EditorialTextField(
                  controller: _titleController,
                  prefixIcon: Icon(Icons.badge_outlined,
                      size: 18.0, color: textSecondary),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Role title is required'
                      : null,
                ),
                const SizedBox(height: EditorialSpacing.spaceMd),

                // Field 4: Annual Hiring Velocity 2x2 Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ANNUAL HIRING VELOCITY',
                      style:
                          EditorialTypography.labelStamp(color: textSecondary),
                    ),
                    Text(
                      'Pipeline Allocation',
                      style: EditorialTypography.bodySm(color: textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.8,
                  children: _volumeTiers.map((t) {
                    final isSelected = _selectedTier == t['tier'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTier = t['tier']!),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: EditorialRadii.roundedMd,
                          border: Border.all(
                            color: isSelected
                                ? EditorialColors.primary
                                : hairlineColor,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              t['tier']!,
                              style: EditorialTypography.labelStamp(
                                color: isSelected
                                    ? EditorialColors.primary
                                    : textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              t['volume']!,
                              style: EditorialTypography.labelMd(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              t['scope']!,
                              style: EditorialTypography.bodySm(
                                  color: textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: EditorialSpacing.spaceXl),

                // Primary CTA
                EditorialButton(
                  label: 'Initialize Organization Ledger & Next',
                  trailingIcon: const Icon(Icons.arrow_forward,
                      size: 18.0, color: Colors.white),
                  onPressed: _submit,
                ),
                const SizedBox(height: EditorialSpacing.spaceLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
