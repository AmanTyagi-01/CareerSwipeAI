import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Role Selection Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/account_role_selection`
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserType _selectedRole = UserType.talent;

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
              // Top Metadata
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
                        'ROLE DISPATCH PROTOCOL',
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
                      'DUAL-SIDED ECOSYSTEM',
                      style: EditorialTypography.labelStamp(color: textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EditorialSpacing.spaceMd),

              // Editorial Headline
              Text(
                'Select your operating mandate.',
                style: EditorialTypography.headlineXlMobile(color: textPrimary),
              ),
              const SizedBox(height: EditorialSpacing.spaceXs),
              Text(
                'CareerSwipe AI operates on verified signal. Choose whether you are advancing your engineering career or acquiring technical talent.',
                style: EditorialTypography.bodyMd(color: textSecondary),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Candidate Role Card
              _buildRoleCard(
                context,
                role: UserType.talent,
                category: 'CANDIDATE WORKSPACE',
                title: 'I am seeking jobs or internships',
                description:
                    'Upload your resume, verify competencies against real job specs, swipe through curated roles, and track interview progressions with zero synthetic metrics.',
                capabilities: [
                  'Grounded ATS requirement matching',
                  'Direct verified application dispatch',
                  'Tailored interview preparation simulator',
                ],
                scopeNote: 'Recommended for individual talent',
                isSelected: _selectedRole == UserType.talent,
                onTap: () => setState(() => _selectedRole = UserType.talent),
                surfaceColor: surfaceColor,
                hairlineColor: hairlineColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                isDark: isDark,
              ),
              const SizedBox(height: EditorialSpacing.spaceMd),

              // Recruiter Role Card
              _buildRoleCard(
                context,
                role: UserType.recruiter,
                category: 'RECRUITER WORKSPACE',
                title: 'I am hiring talent for my company',
                description:
                    'Publish verified job & internship postings, screen applicants with genuine requirement evidence, and manage structured interview pipelines.',
                capabilities: [
                  'Evidence-based candidate filtering',
                  'Transparent compensation listing',
                  'Team pipeline management & scheduling',
                ],
                scopeNote: 'Recommended for hiring managers & founders',
                isSelected: _selectedRole == UserType.recruiter,
                onTap: () => setState(() => _selectedRole = UserType.recruiter),
                surfaceColor: surfaceColor,
                hairlineColor: hairlineColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                isDark: isDark,
              ),
              const SizedBox(height: EditorialSpacing.spaceXl),

              // Confirm CTA
              EditorialButton(
                label: 'Confirm Selected Workspace',
                trailingIcon: const Icon(Icons.arrow_forward, size: 18.0, color: Colors.white),
                onPressed: () {
                  ref.read(selectedUserTypeProvider.notifier).state = _selectedRole;
                  if (_selectedRole == UserType.talent) {
                    context.push('/auth/signup');
                  } else {
                    context.push('/auth/recruiter-onboarding');
                  }
                },
              ),
              const SizedBox(height: EditorialSpacing.spaceMd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required UserType role,
    required String category,
    required String title,
    required String description,
    required List<String> capabilities,
    required String scopeNote,
    required bool isSelected,
    required VoidCallback onTap,
    required Color surfaceColor,
    required Color hairlineColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final activeBorderColor = isSelected ? EditorialColors.primary : hairlineColor;
    final activeBorderWidth = isSelected ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(EditorialSpacing.spaceMd),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: activeBorderColor, width: activeBorderWidth),
          boxShadow: isDark
              ? (isSelected ? EditorialElevation.paperCardDark : null)
              : (isSelected ? EditorialElevation.paperCard : null),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: EditorialTypography.labelStamp(
                    color: isSelected ? EditorialColors.primary : textSecondary,
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: const BoxDecoration(
                      color: EditorialColors.primary,
                      borderRadius: EditorialRadii.roundedSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, size: 12.0, color: Colors.white),
                        const SizedBox(width: 4.0),
                        Text(
                          'SELECTED',
                          style: EditorialTypography.labelStamp(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6.0),
            Text(
              title,
              style: EditorialTypography.headlineMd(color: textPrimary),
            ),
            const SizedBox(height: EditorialSpacing.spaceSm),
            Text(
              description,
              style: EditorialTypography.bodyMd(color: textSecondary),
            ),
            const SizedBox(height: EditorialSpacing.spaceSm),

            // Inset Key Capabilities
            Container(
              padding: const EdgeInsets.all(EditorialSpacing.spaceSm),
              decoration: BoxDecoration(
                color: isDark ? EditorialColors.darkContainerLow : EditorialColors.paperContainerLow,
                borderRadius: EditorialRadii.roundedMd,
              ),
              child: Column(
                children: capabilities.map((cap) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 15.0,
                          color: isSelected ? EditorialColors.primary : textSecondary,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            cap,
                            style: EditorialTypography.bodySm(
                              color: textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: EditorialSpacing.spaceSm),

            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: isSelected ? EditorialColors.primary : textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                  scopeNote,
                  style: EditorialTypography.bodySm(color: textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
