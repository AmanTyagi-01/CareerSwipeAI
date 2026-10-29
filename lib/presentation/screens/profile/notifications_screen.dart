import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../core/utils/app_utils.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/notification_provider.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';
import '../../../presentation/widgets/common/loading_indicator.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final notificationsAsync = user != null
        ? ref.watch(notificationsProvider(user.id))
        : const AsyncValue<List<dynamic>>.data([]);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              if (user != null) {
                ref.read(notificationNotifierProvider.notifier).markAllAsRead(user.id);
              }
            },
            child: const Text('Mark All Read'),
          ),
        ],
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return _buildEmptyState(context, isDark);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(context, notifications[index], user?.id ?? '', ref, isDark)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: index * 50))
                      .slideX(begin: -0.1, end: 0);
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
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 60,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll notify you about job matches and updates",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, dynamic notification, String userId, WidgetRef ref, bool isDark) {
    final typeColors = {
      'job_match': AppTheme.successColor,
      'application_update': AppTheme.primaryColor,
      'resume_analysis': AppTheme.accentColor,
      'system': AppTheme.warningColor,
    };

    final typeIcons = {
      'job_match': Icons.work_outline,
      'application_update': Icons.update,
      'resume_analysis': Icons.analytics_outlined,
      'system': Icons.info_outline,
    };

    final color = typeColors[notification.type] ?? AppTheme.primaryColor;
    final icon = typeIcons[notification.type] ?? Icons.notifications_outlined;
    final isRead = notification.isRead ?? false;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: AppTheme.errorColor),
      ),
      onDismissed: (_) {
        ref.read(notificationNotifierProvider.notifier).deleteNotification(notification.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () {
              if (!isRead) {
                ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id);
              }
              if (notification.actionUrl != null) {
                context.push(notification.actionUrl);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppUtils.formatRelativeTime(notification.createdAt ?? DateTime.now()),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
