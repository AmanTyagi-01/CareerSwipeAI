import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class CandidateDetailsScreen extends StatelessWidget {
  final String candidateName;
  const CandidateDetailsScreen({super.key, required this.candidateName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              GlassCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.2),
                      child: Text(
                        candidateName.isNotEmpty ? candidateName[0] : 'C',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkPrimary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      candidateName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Full Stack Mobile & AI Developer',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.darkSuccess.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(color: AppColors.darkSuccess.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 16, color: AppColors.darkSuccess),
                          SizedBox(width: 6),
                          Text(
                            '92% Match with Job Requirements',
                            style: TextStyle(color: AppColors.darkSuccess, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Key Skills
              const GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('Python')),
                        Chip(label: Text('REST APIs')),
                        Chip(label: Text('Firebase')),
                        Chip(label: Text('Git')),
                        Chip(label: Text('State Management')),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Experience
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Work Experience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.md),
                    _buildTimelineItem(
                      title: 'Senior Software Engineer',
                      subtitle: 'TechNova Solutions • 2024 - Present',
                      description: 'Architected high-throughput mobile application clients using Flutter & Riverpod.',
                      isDark: isDark,
                    ),
                    const Divider(height: 24),
                    _buildTimelineItem(
                      title: 'Software Developer',
                      subtitle: 'TCS • 2022 - 2024',
                      description: 'Engineered cross-platform APIs, CI/CD automated test suites, and microservices.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Education
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Education', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'B.Tech in Computer Science & Engineering',
                      style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                    Text(
                      'Indian Institute of Technology • 2018 - 2022',
                      style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Candidate application rejected')),
                        );
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.darkError,
                        side: const BorderSide(color: AppColors.darkError),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/recruiter/schedule-interview', extra: candidateName);
                      },
                      child: const Text('Schedule Interview'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String description,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
          ),
        ),
      ],
    );
  }
}

