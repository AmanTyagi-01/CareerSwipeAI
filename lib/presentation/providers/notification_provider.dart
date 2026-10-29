import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';
import '../../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final notificationsProvider = FutureProvider.family<List<NotificationModel>, String>((ref, userId) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getNotifications(userId);
});

final unreadCountProvider = FutureProvider.family<int, String>((ref, userId) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getUnreadCount(userId);
});

class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationService _service;

  NotificationNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadNotifications(String userId) async {
    try {
      final notifications = await _service.getNotifications(userId);
      state = AsyncValue.data(notifications);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);
      state.whenData((notifications) {
        final updated = notifications.map((n) => 
          n.id == notificationId ? n.copyWith(isRead: true) : n
        ).toList();
        state = AsyncValue.data(updated);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await _service.markAllAsRead(userId);
      state.whenData((notifications) {
        final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
        state = AsyncValue.data(updated);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _service.deleteNotification(notificationId);
      state.whenData((notifications) {
        final updated = notifications.where((n) => n.id != notificationId).toList();
        state = AsyncValue.data(updated);
      });
    } catch (e) {
      rethrow;
    }
  }
}

final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationNotifier(ref.watch(notificationServiceProvider));
});
