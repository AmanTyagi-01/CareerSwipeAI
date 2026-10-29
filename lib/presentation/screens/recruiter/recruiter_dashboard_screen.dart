import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class RecruiterDashboardScreen extends ConsumerWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = user?.displayName?.split(' ').first ?? 'Recruiter';
    final companyName = user?.industry?.isNotEmpty == true ? user!.industry! : 'Aman Traders Tech';

    final applicantsAsync = ref.watch(jobApplicantsProvider(''));

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(jobApplicantsProvider(''));
              ref.invalidate(recruiterJobsProvider(user?.id ?? ''));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.2),
                            child: const Icon(Icons.business_rounded, color: AppColors.darkPrimary, size: 28),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Evening, $displayName!',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                companyName,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => context.push('/profile/notifications'),
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                    ],
                  ).animate().fadeIn(duration: AppMotion.standard),

                  const SizedBox(height: AppSpacing.lg),

                  // Overview Header with Range Tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Text(
                          'Last 30 Days',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 4 Metric KPI Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Active Jobs',
                          value: '24',
                          icon: Icons.work_outline_rounded,
                          accentColor: AppColors.darkPrimary,
                          onTap: () => context.push('/recruiter/jobs'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Applicants',
                          value: '312',
                          icon: Icons.people_outline_rounded,
                          accentColor: AppColors.darkSecondary,
                          onTap: () => context.push('/recruiter/pipeline'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Shortlisted',
                          value: '18',
                          icon: Icons.star_outline_rounded,
                          accentColor: AppColors.darkWarning,
                          onTap: () => context.push('/recruiter/pipeline'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Offers',
                          value: '7',
                          icon: Icons.check_circle_outline_rounded,
                          accentColor: AppColors.darkSuccess,
                          onTap: () => context.push('/recruiter/pipeline'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Quick Action Banner: Post a Job
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppRadii.card,
                      boxShadow: AppElevation.darkCardShadow(intensity: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Post a Job or Internship',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Reach verified candidates matched by AI',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/recruiter/create-job'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.darkPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ).animate().scale(delay: const Duration(milliseconds: 100)),

                  const SizedBox(height: AppSpacing.xl),

                  // Recent Applications Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Applications',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => context.push('/recruiter/pipeline'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Applicant List
                  applicantsAsync.when(
                    data: (apps) {
                      final candidates = [
                        {
                          'name': 'Rahul Sharma',
                          'role': 'Software Developer',
                          'match': '92% Match',
                          'tone': AppStatusTone.success,
                          'status': 'Shortlisted',
                        },
                        {
                          'name': 'Priya Singh',
                          'role': 'Frontend Developer',
                          'match': '88% Match',
                          'tone': AppStatusTone.success,
                          'status': 'Reviewing',
                        },
                        {
                          'name': 'Arjun Verma',
                          'role': 'Backend Developer',
                          'match': '85% Match',
                          'tone': AppStatusTone.warning,
                          'status': 'Interview',
                        },
                        {
                          'name': 'Neha Patel',
                          'role': 'Data Analyst',
                          'match': '77% Match',
                          'tone': AppStatusTone.neutral,
                          'status': 'Applied',
                        },
                      ];

                      return Column(
                        children: candidates.map((c) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: GlassCard(
                              onTap: () => context.push('/recruiter/candidate-details', extra: c['name']),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.15),
                                    child: Text(
                                      (c['name'] as String).substring(0, 1),
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPrimary),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c['name'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        Text(
                                          c['role'] as String,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor(context, c['tone'] as AppStatusTone).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppRadii.pill),
                                      border: Border.all(
                                        color: statusColor(context, c['tone'] as AppStatusTone).withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      c['match'] as String,
                                      style: TextStyle(
                                        color: statusColor(context, c['tone'] as AppStatusTone),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
                    error: (e, _) => Center(child: Text('Failed to load applicants: $e')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

