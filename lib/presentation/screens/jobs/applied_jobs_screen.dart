import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../core/utils/app_utils.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';
import '../../../presentation/widgets/common/loading_indicator.dart';

class AppliedJobsScreen extends ConsumerWidget {
  const AppliedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final appliedJobsAsync = user != null
        ? ref.watch(appliedJobsProvider(user.id))
        : const AsyncValue<List<dynamic>>.data([]);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applied Jobs'),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: appliedJobsAsync.when(
            data: (applications) {
              if (applications.isEmpty) {
                return _buildEmptyState(context, isDark);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return _buildApplicationCard(context, applications[index], isDark)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: index * 100))
                      .slideY(begin: 0.2, end: 0);
                },
              );
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (error, _) => Center(
              child: Text('Error: \$error', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send_outlined,
              size: 60,
              color: AppTheme.accentColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Applications Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apply to jobs and track your applications here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/jobs/swipe'),
            icon: const Icon(Icons.search),
            label: const Text('Find Jobs'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, dynamic application, bool isDark) {
    final statusColors = {
      'pending': AppTheme.warningColor,
      'reviewing': AppTheme.infoColor,
      'interview': AppTheme.primaryColor,
      'offered': AppTheme.successColor,
      'rejected': AppTheme.errorColor,
      'withdrawn': AppTheme.darkTextTertiary,
    };

    final status = application.status ?? 'pending';
    final statusColor = statusColors[status] ?? AppTheme.infoColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppUtils.formatRelativeTime(application.appliedAt ?? DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Senior Flutter Developer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'TechCorp Inc.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeline(context, status, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, String currentStatus, bool isDark) {
    final stages = ['Applied', 'Reviewing', 'Interview', 'Offered'];
    final currentIndex = stages.indexOf(currentStatus.substring(0, 1).toUpperCase() + currentStatus.substring(1));

    return Row(
      children: stages.asMap().entries.map((entry) {
        final index = entry.key;

        final isCompleted = index <= currentIndex && currentIndex >= 0;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? AppTheme.successColor
                        : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                  ),
                ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successColor
                      : (isDark ? AppTheme.darkElevated : AppTheme.lightElevated),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? AppTheme.primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              if (index < stages.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? AppTheme.successColor
                        : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
