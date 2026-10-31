import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/app_utils.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final notificationsAsync = user != null
        ? ref.watch(notificationsProvider(user.id))
        : const AsyncValue<List<dynamic>>.data([]);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () {
              if (user != null) {
                ref.read(notificationNotifierProvider.notifier).markAllAsRead(user.id);
              }
            },
            child: const Text('Mark All Read', style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return _buildSampleOrEmptyState(context, user?.id ?? '', ref);
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(context, notifications[index], user?.id ?? '', ref)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: index * 50))
                    .slideX(begin: -0.05, end: 0);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error', style: const TextStyle(color: Color(0xFFEF4444))),
          ),
        ),
      ),
    );
  }

  Widget _buildSampleOrEmptyState(BuildContext context, String userId, WidgetRef ref) {
    // If empty in mock mode, provide the poster's 4 standard notification items for high fidelity preview
    final sampleNotifications = [
      {
        'id': 'notif-1',
        'type': 'interview',
        'title': 'Interview Scheduled',
        'body': 'Google · Software Engineer - Round 1 tomorrow at 3:00 PM',
        'time': '2 hours ago',
        'isRead': false,
        'actionUrl': '/jobs/applied',
      },
      {
        'id': 'notif-2',
        'type': 'application_update',
        'title': 'Application Update',
        'body': 'Microsoft · Product Intern application moved to Shortlisted stage',
        'time': '1 day ago',
        'isRead': false,
        'actionUrl': '/jobs/applied',
      },
      {
        'id': 'notif-3',
        'type': 'job_match',
        'title': 'New Job Match (94%)',
        'body': 'Amazon opened Senior Flutter Developer role matching your skills',
        'time': '2 days ago',
        'isRead': true,
        'actionUrl': '/jobs/details',
      },
      {
        'id': 'notif-4',
        'type': 'message',
        'title': 'Message From Recruiter',
        'body': 'Swiggy recruiter viewed your resume and sent an invitation',
        'time': '3 days ago',
        'isRead': true,
        'actionUrl': '/ai/assistant',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: sampleNotifications.length,
      itemBuilder: (context, index) {
        final item = sampleNotifications[index];
        final type = item['type'] as String;
        final isRead = item['isRead'] as bool;

        Color iconColor;
        IconData iconData;

        switch (type) {
          case 'interview':
            iconColor = const Color(0xFF10B981);
            iconData = Icons.event_available_rounded;
            break;
          case 'application_update':
            iconColor = const Color(0xFF8B5CF6);
            iconData = Icons.sync_alt_rounded;
            break;
          case 'job_match':
            iconColor = const Color(0xFF38BDF8);
            iconData = Icons.auto_awesome_rounded;
            break;
          case 'message':
            iconColor = const Color(0xFFF59E0B);
            iconData = Icons.chat_bubble_outline_rounded;
            break;
          default:
            iconColor = const Color(0xFF8B5CF6);
            iconData = Icons.notifications_none_rounded;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF121622),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead ? const Color(0xFF232A3B) : const Color(0xFF8B5CF6).withValues(alpha: 0.4),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                final url = item['actionUrl'] as String?;
                if (url != null) context.push(url);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconData, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    color: const Color(0xFFF1F5F9),
                                    fontSize: 14,
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF38BDF8),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['body'] as String,
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['time'] as String,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 60)).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildNotificationCard(BuildContext context, dynamic notification, String userId, WidgetRef ref) {
    final typeColors = {
      'job_match': const Color(0xFF38BDF8),
      'application_update': const Color(0xFF8B5CF6),
      'resume_analysis': const Color(0xFF10B981),
      'system': const Color(0xFFF59E0B),
    };

    final typeIcons = {
      'job_match': Icons.auto_awesome_rounded,
      'application_update': Icons.sync_alt_rounded,
      'resume_analysis': Icons.analytics_outlined,
      'system': Icons.info_outline_rounded,
    };

    final color = typeColors[notification.type] ?? const Color(0xFF8B5CF6);
    final icon = typeIcons[notification.type] ?? Icons.notifications_none_rounded;
    final isRead = notification.isRead ?? false;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
      ),
      onDismissed: (_) {
        ref.read(notificationNotifierProvider.notifier).deleteNotification(notification.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF121622),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? const Color(0xFF232A3B) : const Color(0xFF8B5CF6).withValues(alpha: 0.4),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (!isRead) {
                ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id);
              }
              if (notification.actionUrl != null) {
                context.push(notification.actionUrl);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  color: const Color(0xFFF1F5F9),
                                  fontSize: 14,
                                  fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF38BDF8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          notification.body,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppUtils.formatRelativeTime(notification.createdAt ?? DateTime.now()),
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
