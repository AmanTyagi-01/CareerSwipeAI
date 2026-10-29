import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../data/models/resume_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class SkillGapScreen extends ConsumerStatefulWidget {
  const SkillGapScreen({super.key});

  @override
  ConsumerState<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends ConsumerState<SkillGapScreen> {
  String _selectedRole = 'Senior Flutter Developer';
  
  final Map<String, List<String>> _roleSkills = {
    'Senior Flutter Developer': ['Flutter', 'Dart', 'Firebase', 'State Management', 'CI/CD', 'Unit Testing', 'GraphQL', 'Native iOS/Android'],
    'Product Designer': ['Figma', 'UI/UX', 'Prototyping', 'User Research', 'Design Systems', 'HTML/CSS', 'Micro-interactions'],
    'Full Stack Engineer': ['React', 'Node.js', 'TypeScript', 'AWS', 'GraphQL', 'Docker', 'Database Design', 'REST APIs'],
  };

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Skill Gap Analysis'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.transparent],
            ),
          ),
        ),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              if (user == null) {
                return const Center(child: Text('Please log in to see skill gap analysis.'));
              }
              // Fetch user resumes to get the active one
              final resumesAsync = ref.watch(userResumesProvider(user.id));
              return resumesAsync.when(
                data: (resumes) {
                  final activeResume = resumes.isEmpty 
                      ? null 
                      : resumes.firstWhere((r) => r.isActive, orElse: () => resumes.first);

                  if (activeResume == null) {
                    return _buildNoResumeState(context);
                  }

                  return _buildAnalysisContent(context, activeResume, isDark);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResumeState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80,
                  color: AppTheme.primaryColor.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 24),
                Text(
                  'No Resume Uploaded',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upload your resume to unlock real-time AI skill gap analysis against industry-leading job roles.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to resume upload
                    Navigator.of(context).pop(); // Or router push
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Go to Resume Upload'),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
      ),
    );
  }

  Widget _buildAnalysisContent(BuildContext context, ResumeModel resume, bool isDark) {
    final targetSkills = _roleSkills[_selectedRole] ?? [];
    final userSkills = resume.skills.isNotEmpty 
        ? resume.skills 
        : const ['Flutter', 'Dart', 'Firebase', 'State Management', 'REST APIs'];
        
    final matchingSkills = targetSkills.where((s) => userSkills.any((u) => u.toLowerCase() == s.toLowerCase())).toList();
    final missingSkills = targetSkills.where((s) => !userSkills.any((u) => u.toLowerCase() == s.toLowerCase())).toList();
    
    final matchPercentage = targetSkills.isEmpty 
        ? 0.0 
        : (matchingSkills.length / targetSkills.length) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Selector Card
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.work_outline, color: AppTheme.accentColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        items: _roleSkills.keys.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedRole = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
          
          const SizedBox(height: 20),
          
          // Match Score Circular Indicator
          Center(
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'ATS Compatibility Score',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: matchPercentage / 100,
                            strokeWidth: 12,
                            backgroundColor: isDark ? Colors.white10 : Colors.black12,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${matchPercentage.toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Text(
                              'Match',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      matchPercentage >= 75 
                          ? 'Excellent fit! You possess the key skills required.' 
                          : 'Potential fit. Consider acquiring the missing skills below.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms).scale(),

          const SizedBox(height: 24),

          // Matching Skills Section
          Text(
            'Matching Skills (${matchingSkills.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: matchingSkills.map((skill) {
              return Chip(
                avatar: const Icon(Icons.check_circle, color: AppTheme.successColor, size: 18),
                label: Text(skill),
                backgroundColor: AppTheme.successColor.withValues(alpha: 0.1),
                side: BorderSide(color: AppTheme.successColor.withValues(alpha: 0.2)),
              );
            }).toList(),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Missing Skills & Gap Analysis Section
          Text(
            'Missing Skills Gaps (${missingSkills.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (missingSkills.isEmpty)
            Card(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.warningColor),
                    SizedBox(width: 12),
                    Expanded(child: Text('Perfect Match! You have no skill gaps for this role.')),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: missingSkills.length,
              itemBuilder: (context, index) {
                final skill = missingSkills[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor.withValues(alpha: 0.8)),
                              const SizedBox(width: 12),
                              Text(
                                skill,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              Text(
                                'High Priority',
                                style: TextStyle(
                                  color: AppTheme.errorColor.withValues(alpha: 0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          const Text(
                            'AI Recommendations:',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'To close this gap, complete a dedicated project utilizing $skill or read official documentation. Adding 1-2 bullet points showcasing $skill will significantly boost your ATS response rate.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (250 + (index * 50)).ms, duration: 300.ms).slideX(begin: 0.05);
              },
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
