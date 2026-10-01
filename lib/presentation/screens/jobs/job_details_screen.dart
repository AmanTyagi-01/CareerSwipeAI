import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/job_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';
import '../../../presentation/widgets/common/custom_buttons.dart';

class JobDetailsScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider).value;

    // Mock job data - in production, fetch from provider using jobId
    final job = JobModel(
      id: jobId,
      title: 'Senior Flutter Developer',
      company: 'TechCorp Inc.',
      description: '''We are looking for an experienced Flutter developer to lead our mobile team. You will be responsible for architecting and building cross-platform applications that serve millions of users worldwide.

As a Senior Flutter Developer, you will:
- Lead the design and implementation of new features
- Mentor junior developers and conduct code reviews
- Optimize application performance and ensure code quality
- Collaborate with product managers and designers
- Implement CI/CD pipelines and automated testing
- Stay up-to-date with the latest Flutter and Dart developments''',
      requirements: const [
        '5+ years of experience in mobile development',
        '3+ years of experience with Flutter',
        'Strong understanding of Dart programming language',
        'Experience with state management (Bloc, Riverpod, Provider)',
        'Knowledge of REST APIs and GraphQL',
        'Experience with Firebase services',
        'Understanding of CI/CD practices',
        'Excellent problem-solving and communication skills',
      ],
      responsibilities: const [
        'Design and develop new features for our mobile applications',
        'Maintain and improve existing codebase',
        'Write clean, maintainable, and testable code',
        'Collaborate with cross-functional teams',
        'Participate in architectural decisions',
        'Mentor and guide junior team members',
      ],
      skills: const ['Flutter', 'Dart', 'Firebase', 'State Management', 'CI/CD', 'REST APIs', 'GraphQL', 'Git'],
      experienceLevel: 'Senior',
      jobType: 'Full-time',
      location: 'San Francisco, CA',
      isRemote: true,
      minSalary: 140000,
      maxSalary: 180000,
      currency: 'USD',
      industry: 'Technology',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      viewCount: 234,
      applyCount: 45,
    );

    return Scaffold(
      body: AnimatedBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.3),
                        AppTheme.accentColor.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.glowShadow,
                          ),
                          child: Center(
                            child: Text(
                              AppUtils.getInitials(job.company),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          job.company,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share_outlined, size: 20),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bookmark_border, size: 20),
                  ),
                  onPressed: () {
                    if (user != null) {
                      ref.read(jobNotifierProvider.notifier).saveJob(user.id, job.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Job saved successfully!'),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate()
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 16),
                    _buildJobMeta(context, job, isDark),
                    const SizedBox(height: 24),
                    _buildSalaryCard(context, job, isDark),
                    const SizedBox(height: 24),
                    _buildSection(context, 'About the Role', job.description, isDark),
                    const SizedBox(height: 24),
                    _buildSection(context, 'Requirements', null, isDark, items: job.requirements),
                    const SizedBox(height: 24),
                    _buildSection(context, 'Responsibilities', null, isDark, items: job.responsibilities),
                    const SizedBox(height: 24),
                    _buildSkillsSection(context, job, isDark),
                    const SizedBox(height: 24),
                    _buildStatsSection(context, job, isDark),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Apply Now',
                      onPressed: () => _showApplyDialog(context, job, user, ref),
                      icon: const Icon(Icons.send_outlined, size: 20),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobMeta(BuildContext context, JobModel job, bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildMetaChip(context, job.jobType ?? 'Full-time', Icons.schedule, AppTheme.primaryColor, isDark),
        _buildMetaChip(context, job.experienceLevel ?? 'Mid-Level', Icons.trending_up, AppTheme.accentColor, isDark),
        if (job.isRemote)
          _buildMetaChip(context, 'Remote', Icons.home, AppTheme.successColor, isDark),
        _buildMetaChip(context, job.location ?? 'Not specified', Icons.location_on, AppTheme.infoColor, isDark),
        _buildMetaChip(context, AppUtils.formatRelativeTime(job.postedAt ?? DateTime.now()), Icons.access_time, AppTheme.warningColor, isDark),
      ],
    );
  }

  Widget _buildMetaChip(BuildContext context, String label, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(BuildContext context, JobModel job, bool isDark) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.attach_money, color: AppTheme.successColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salary Range',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppUtils.formatSalary(job.minSalary, job.maxSalary, job.currency ?? 'USD'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String? content, bool isDark, {List<String>? items}) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (content != null)
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.7,
              ),
            ),
          if (items != null)
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, JobModel job, bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Required Skills',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: job.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.accentColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, JobModel job, bool isDark) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(context, job.viewCount.toString(), 'Views', Icons.visibility, AppTheme.primaryColor),
          Container(width: 1, height: 40, color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildStat(context, job.applyCount.toString(), 'Applicants', Icons.people, AppTheme.accentColor),
          Container(width: 1, height: 40, color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildStat(context, '92%', 'Match', Icons.thumb_up, AppTheme.successColor),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  void _showApplyDialog(BuildContext context, JobModel job, dynamic user, WidgetRef ref) {
    final coverLetterController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Apply for ${job.title}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'at ${job.company}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cover Letter (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: coverLetterController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Tell us why you're a great fit for this role...",
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Submit Application',
              onPressed: () async {
                if (user != null) {
                  await ref.read(jobNotifierProvider.notifier).applyForJob(
                    user.id,
                    job.id,
                    coverLetter: coverLetterController.text.isEmpty ? null : coverLetterController.text,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Application submitted successfully!'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
