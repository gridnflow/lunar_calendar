import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/family_anniversary.dart';
import 'lunar_service.dart';

/// Must be a top-level function for background message handling.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

class NotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  NotificationService({FirebaseMessaging? fcm})
      : _fcm = fcm ?? FirebaseMessaging.instance;

  Future<void> initialize() async {
    // ── timezone ──────────────────────────────────────────────────────────
    tz_data.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

    // ── FCM ───────────────────────────────────────────────────────────────
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Foreground message: ${message.notification?.title}');
    });

    // ── Local notifications ───────────────────────────────────────────────
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _local.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
    );

    // Android 13+ 알림 권한 요청
    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<String?> getToken() async => _fcm.getToken();

  Future<void> subscribeToTopic(String topic) =>
      _fcm.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _fcm.unsubscribeFromTopic(topic);

  // ── Anniversary scheduling ─────────────────────────────────────────────

  static const _androidDetails = AndroidNotificationDetails(
    'anniversary_channel',
    '기념일 알림',
    channelDescription: '가족 기념일 사전 알림',
    importance: Importance.high,
    priority: Priority.high,
  );
  static const _notificationDetails =
      NotificationDetails(android: _androidDetails);

  /// 기존 기념일 알림을 모두 취소하고 새로 스케줄링합니다.
  Future<void> scheduleAnniversaryNotifications(
    List<FamilyAnniversary> anniversaries,
    LunarService lunar,
  ) async {
    await _local.cancelAll();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final ann in anniversaries) {
      DateTime? nextSolar;

      // 올해 또는 내년 중 오늘 이후 첫 번째 날짜 찾기
      for (final year in [now.year, now.year + 1]) {
        try {
          final solar = lunar.lunarToSolar(
              year, ann.lunarMonth, ann.lunarDay,
              isLeap: ann.isLeap);
          final solarDay = DateTime(solar.year, solar.month, solar.day);
          if (!solarDay.isBefore(today)) {
            nextSolar = solarDay;
            break;
          }
        } catch (_) {}
      }

      if (nextSolar == null) continue;

      final baseId = ann.id.hashCode.abs() % 100000;

      final schedules = [
        (offset: 7, idx: 0, msg: '1주일 후입니다'),
        (offset: 3, idx: 1, msg: '3일 후입니다'),
        (offset: 0, idx: 2, msg: '오늘입니다! 🎉'),
      ];

      for (final s in schedules) {
        final targetDay = nextSolar.subtract(Duration(days: s.offset));
        // 오전 9시에 알림
        final scheduleAt = DateTime(
            targetDay.year, targetDay.month, targetDay.day, 9, 0);

        if (scheduleAt.isAfter(now)) {
          await _local.zonedSchedule(
            id: baseId * 3 + s.idx,
            title: '기념일 알림 · ${ann.type}',
            body:
                '${ann.name} (음력 ${ann.lunarMonth}/${ann.lunarDay}) ${s.msg}',
            scheduledDate: tz.TZDateTime.from(scheduleAt, tz.local),
            notificationDetails: _notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
        }
      }
    }
  }
}
