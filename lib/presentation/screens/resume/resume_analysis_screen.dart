import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';

class ResumeAnalysisScreen extends ConsumerWidget {
  final String analysisId;

  const ResumeAnalysisScreen({super.key, required this.analysisId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock analysis data - in production, fetch from provider
    final analysisData = {
      'atsScore': 85.0,
      'keywordMatch': 78.0,
      'formattingScore': 92.0,
      'contentScore': 80.0,
      'overallScore': 83.75,
      'detectedSkills': [
        'Flutter', 'Dart', 'Firebase', 'State Management',
        'REST APIs', 'UI/UX Design', 'Git', 'Agile',
      ],
      'missingSkills': [
        'CI/CD', 'Unit Testing', 'GraphQL', 'Native Development',
        'Performance Optimization', 'Accessibility',
      ],
      'strengths': [
        'Strong mobile development experience',
        'Clean and modern UI design skills',
        'Good understanding of state management patterns',
        'Experience with cloud services integration',
      ],
      'improvements': [
        'Add more quantifiable achievements',
        'Include CI/CD pipeline experience',
        'Mention specific performance metrics',
        'Add testing methodology details',
        'Include more leadership examples',
      ],
      'keywords': [
        'Flutter', 'Mobile Development', 'Cross-platform',
        'Firebase', 'REST API', 'Git', 'Agile', 'Scrum',
        'UI/UX', 'State Management', 'Dart',
      ],
      'summary': 'Your resume demonstrates strong technical skills in mobile development with Flutter. The formatting is clean and ATS-friendly. To improve, focus on adding quantifiable achievements, expanding your testing experience, and including more leadership examples.',
      'sectionScores': {
        'contact_info': 95.0,
        'summary': 72.0,
        'experience': 85.0,
        'education': 88.0,
        'skills': 78.0,
        'projects': 65.0,
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallScore(context, analysisData, isDark),
                const SizedBox(height: 24),
                _buildScoreBreakdown(context, analysisData, isDark),
                const SizedBox(height: 24),
                _buildSkillsAnalysis(context, analysisData, isDark),
                const SizedBox(height: 24),
                _buildStrengths(context, analysisData, isDark),
                const SizedBox(height: 24),
                _buildImprovements(context, analysisData, isDark),
                const SizedBox(height: 24),
                _buildKeywords(context, analysisData, isDark),
                const SizedBox(height: 24),
                _buildSummary(context, analysisData, isDark),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScore(BuildContext context, Map<String, dynamic> data, bool isDark) {
    final score = data['overallScore'] as double;
    final color = AppConstants.getScoreColor(score);
    final label = AppConstants.getScoreLabel(score);

    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Score',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.5), width: 3),
                ),
                child: Center(
                  child: Text(
                    score.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: isDark ? AppTheme.darkElevated : AppTheme.lightElevated,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 12,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn()
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildScoreBreakdown(BuildContext context, Map<String, dynamic> data, bool isDark) {
    final sectionScores = data['sectionScores'] as Map<String, dynamic>;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...sectionScores.entries.map((entry) {
            final score = (entry.value as num).toDouble();
            final color = AppConstants.getScoreColor(score);
            final label = entry.key.replaceAll('_', ' ').toUpperCase();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        score.toStringAsFixed(0),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: isDark ? AppTheme.darkElevated : AppTheme.lightElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 100))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSkillsAnalysis(BuildContext context, Map<String, dynamic> data, bool isDark) {
    final detected = data['detectedSkills'] as List<dynamic>;
    final missing = data['missingSkills'] as List<dynamic>;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Detected Skills (${detected.length})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: detected.map((skill) => _buildSkillChip(context, skill as String, true, isDark)).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Missing/Recommended Skills (${missing.length})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.warningColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: missing.map((skill) => _buildSkillChip(context, skill as String, false, isDark)).toList(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSkillChip(BuildContext context, String skill, bool detected, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: detected
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : AppTheme.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: detected
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : AppTheme.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            detected ? Icons.check_circle : Icons.add_circle_outline,
            color: detected ? AppTheme.successColor : AppTheme.warningColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            skill,
            style: TextStyle(
              color: detected ? AppTheme.successColor : AppTheme.warningColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengths(BuildContext context, Map<String, dynamic> data, bool isDark) {
    final strengths = data['strengths'] as List<dynamic>;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.thumb_up, color: AppTheme.successColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Strengths',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...strengths.map((strength) => _buildBulletPoint(context, strength as String, AppTheme.successColor, isDark)),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildImprovements(BuildContext context, Map<String, dynamic> data, bool isDark) {
    final improvements = data['improvements'] as List<dynamic>;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb, color: AppTheme.warningColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Areas for Improvement',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...improvements.map((improvement) => _buildBulletPoint(context, improvement as String, AppTheme.warningColor, isDark)),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildBulletPoint(BuildContext context, String text, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywords(BuildContext context, Map<String, dynamic> data, bool isDark) {
    final keywords = data['keywords'] as List<dynamic>;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detected Keywords',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((keyword) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.15),
                      AppTheme.accentColor.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  keyword as String,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 500))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSummary(BuildContext context, Map<String, dynamic> data, bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.05),
                  AppTheme.accentColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
              ),
            ),
            child: Text(
              data['summary'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Optimize Resume'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }
}
