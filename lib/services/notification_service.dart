import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../core/errors/exceptions.dart';
import '../core/utils/logger.dart';
import '../data/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore? _firestore;
  final FirebaseMessaging? _messaging;
  final FirebaseAuth? _auth;

  static final List<NotificationModel> _demoNotifications = [
    NotificationModel(
      id: 'notif-1',
      userId: 'mock-user-1',
      title: 'Welcome to CareerSwipe AI! 🚀',
      body: 'Explore top job matches curated for your engineering background.',
      type: 'welcome',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-2',
      userId: 'mock-user-1',
      title: 'Resume ATS Score Ready',
      body: 'Your uploaded resume scored 86/100! View improvements now.',
      type: 'resume',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  NotificationService({
    FirebaseFirestore? firestore,
    FirebaseMessaging? messaging,
    FirebaseAuth? auth,
  })  : _firestore = firestore ??
            (Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null),
        _messaging = messaging ??
            (Firebase.apps.isNotEmpty ? FirebaseMessaging.instance : null),
        _auth =
            auth ?? (Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null);

  Future<void> initialize() async {
    final messaging = _messaging;
    if (messaging == null) {
      AppLogger.info('Push notifications skipped (Demo mode)',
          tag: 'NotificationService');
      return;
    }
    try {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      AppLogger.info('Notification permission: ${settings.authorizationStatus}',
          tag: 'NotificationService');

      final token = await messaging.getToken();
      if (token != null) {
        await _saveToken(token);
      }

      messaging.onTokenRefresh.listen((token) {
        _saveToken(token).catchError((e) {
          AppLogger.warning('Failed to save refreshed FCM token',
              tag: 'NotificationService', error: e);
        });
      });

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      AppLogger.info('NotificationService initialized',
          tag: 'NotificationService');
    } catch (e, stackTrace) {
      // Gracefully handle any missing messaging setup / platform unsupported exceptions
      AppLogger.warning('NotificationService initialization failed (non-fatal)',
          tag: 'NotificationService', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _saveToken(String token) async {
    final uid = _auth?.currentUser?.uid;
    if (uid == null || _firestore == null) return;

    try {
      await _firestore.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'fcmTokenUpdatedAt': Timestamp.fromDate(DateTime.now()),
      });
      AppLogger.info('FCM token saved for user $uid',
          tag: 'NotificationService');
    } on FirebaseException catch (e) {
      AppLogger.warning('Failed to save FCM token: ${e.message}',
          tag: 'NotificationService');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.info(
        'Foreground message received: ${message.notification?.title}',
        tag: 'NotificationService');
    // TODO: Show local notification overlay using flutter_local_notifications
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    AppLogger.info('Background message tapped: ${message.notification?.title}',
        tag: 'NotificationService');
    // TODO: Navigate to relevant screen based on message.data['route']
  }

  Future<List<NotificationModel>> getNotifications(String userId,
      {int limit = 50}) async {
    if (_firestore == null) {
      return List<NotificationModel>.from(_demoNotifications);
    }
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      AppLogger.info('Fetched ${snapshot.docs.length} notifications',
          tag: 'NotificationService');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return NotificationModel.fromMap({...data, 'id': doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching notifications',
          tag: 'NotificationService', error: e);
      throw ServerException(message: 'Failed to fetch notifications.');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching notifications',
          tag: 'NotificationService', error: e, stackTrace: stackTrace);
      throw ServerException(message: 'Failed to fetch notifications.');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (_firestore == null) return;
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error marking notification as read',
          tag: 'NotificationService', error: e);
      throw ServerException(message: 'Failed to mark notification as read.');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    if (_firestore == null) return;
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      final now = Timestamp.fromDate(DateTime.now());
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true, 'readAt': now});
      }

      await batch.commit();
      AppLogger.info('Marked ${snapshot.docs.length} notifications as read',
          tag: 'NotificationService');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error marking all notifications as read',
          tag: 'NotificationService', error: e);
      throw ServerException(
          message: 'Failed to mark all notifications as read.');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    if (_firestore == null) return;
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error deleting notification',
          tag: 'NotificationService', error: e);
      throw ServerException(message: 'Failed to delete notification.');
    }
  }

  Future<int> getUnreadCount(String userId) async {
    if (_firestore == null) return 2;
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      AppLogger.warning('Failed to get unread count',
          tag: 'NotificationService', error: e);
      return 0;
    }
  }
}
