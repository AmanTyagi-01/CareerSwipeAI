import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/editorial/editorial.dart';

/// Candidate Onboarding Screen strictly adhering to Stitch specification:
/// `design_reference/stitch_careerswipe_ai_blueprint_execution_plan/candidate_onboarding_skills_step`
class CandidateOnboardingScreen extends ConsumerStatefulWidget {
  const CandidateOnboardingScreen({super.key});

  @override
  ConsumerState<CandidateOnboardingScreen> createState() => _CandidateOnboardingScreenState();
}

class _CandidateOnboardingScreenState extends ConsumerState<CandidateOnboardingScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedSkills = {'Go (Golang)', 'TypeScript', 'Python', 'SQL / PostgreSQL'};

  final Map<String, List<String>> _skillCategories = {
    'LANGUAGES & SYSTEMS': [
      'Go (Golang)',
      'TypeScript',
      'Python',
      'Rust',
      'C++',
      'SQL / PostgreSQL',
      'Java',
    ],
    'INFRASTRUCTURE & PROTOCOLS': [
      'Kubernetes',
      'Docker',
      'Kafka',
      'gRPC',
      'Redis',
      'Terraform',
    ],
    'ARCHITECTURE & DISTRIBUTED': [
      'Distributed Caching',
      'Event-Driven Systems',
      'High-Throughput APIs',
      'CI/CD Pipelines',
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addCustomSkill() {
    final text = _searchController.text.trim();
    if (text.isNotEmpty && !_selectedSkills.contains(text)) {
      setState(() {
        _selectedSkills.add(text);
        _searchController.clear();
      });
    }
  }

  Future<void> _saveAndContinue() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    // 1. Persist selected skills
    await authNotifier.updateProfile(skills: _selectedSkills.toList());
    // 2. Mark profile complete + set role as talent
    await authNotifier.completeOnboarding(role: UserType.talent);
    if (mounted) {
      // Router redirect will now see isProfileComplete = true → /home
      context.go('/home');
    }
  }

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
              context.go('/home');
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'STEP 2 OF 5 · SKILL PROFILE',
          style: EditorialTypography.labelStamp(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: Text(
              'Save & Exit',
              style: EditorialTypography.labelMd(color: EditorialColors.primary),
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
              // 5-Step Progress Bar
              Row(
                children: List.generate(5, (index) {
                  final isCurrentOrPast = index <= 1;
                  return Expanded(
                    child: Container(
                      height: 4.0,
                      margin: EdgeInsets.only(right: index < 4 ? 4.0 : 0.0),
                      decoration: BoxDecoration(
                        color: isCurrentOrPast ? EditorialColors.primary : hairlineColor,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Editorial Headline
              Text(
                'Declare your core technical pillars.',
                style: EditorialTypography.headlineXlMobile(color: textPrimary),
              ),
              const SizedBox(height: EditorialSpacing.spaceXs),
              Text(
                'Select the competencies you have applied in production or open-source projects. These will be cross-referenced with your uploaded resume.',
                style: EditorialTypography.bodyMd(color: textSecondary),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Search & Add Input Field
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: EditorialRadii.roundedMd,
                  border: Border.all(color: hairlineColor, width: 1.0),
                  boxShadow: isDark ? EditorialElevation.paperCardDark : EditorialElevation.paperCard,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search, size: 20.0, color: textSecondary),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (_) => _addCustomSkill(),
                        decoration: InputDecoration(
                          hintText: 'Search skill or framework (e.g. Distributed Systems)',
                          hintStyle: EditorialTypography.bodyMd(color: textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: EditorialTypography.bodyMd(color: textPrimary),
                      ),
                    ),
                    InkWell(
                      onTap: _addCustomSkill,
                      borderRadius: EditorialRadii.roundedSm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isDark ? EditorialColors.darkContainerMid : EditorialColors.paperContainerLow,
                          borderRadius: EditorialRadii.roundedSm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, size: 16.0, color: EditorialColors.primary),
                            const SizedBox(width: 4.0),
                            Text(
                              'Add',
                              style: EditorialTypography.labelMd(
                                color: EditorialColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),

              // Categorized Interactive Skill Pill Groups
              ..._skillCategories.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: EditorialSpacing.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: EditorialTypography.labelStamp(color: textSecondary),
                          ),
                          Text(
                            '${entry.value.where((s) => _selectedSkills.contains(s)).length} selected',
                            style: EditorialTypography.bodySm(color: textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: EditorialSpacing.spaceSm),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: entry.value.map((skill) {
                          final isSelected = _selectedSkills.contains(skill);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSkills.remove(skill);
                                } else {
                                  _selectedSkills.add(skill);
                                }
                              });
                            },
                            borderRadius: EditorialRadii.roundedMd,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? EditorialColors.primary
                                    : (isDark ? EditorialColors.darkContainerLow : EditorialColors.paperContainerLow),
                                borderRadius: EditorialRadii.roundedMd,
                                border: Border.all(
                                  color: isSelected ? EditorialColors.primary : hairlineColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    const Icon(Icons.check, size: 13.0, color: Colors.white),
                                    const SizedBox(width: 4.0),
                                  ] else ...[
                                    Icon(Icons.add, size: 13.0, color: textSecondary),
                                    const SizedBox(width: 4.0),
                                  ],
                                  Text(
                                    skill,
                                    style: EditorialTypography.labelMd(
                                      color: isSelected ? Colors.white : textPrimary,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: EditorialSpacing.spaceMd),

              // Confirm CTA
              EditorialButton(
                label: 'Confirm ${_selectedSkills.length} Competencies & Continue',
                trailingIcon: const Icon(Icons.arrow_forward, size: 18.0, color: Colors.white),
                onPressed: _selectedSkills.isEmpty ? null : _saveAndContinue,
              ),
              const SizedBox(height: EditorialSpacing.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

