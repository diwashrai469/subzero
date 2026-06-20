import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subzero/core/services/notification/billing_logic.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'subzero_billing';
  static const String _channelName = 'SubZero Billing Alerts';
  static const String _channelDescription = 'Subscription payment reminders';

  static const int _defaultHour = 9;
  static const int _defaultMinute = 0;

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );

    await _createAndroidChannel();

    _initialized = true;
    debugPrint('✅ NotificationService initialized');
  }

  static Future<void> _createAndroidChannel() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final notificationGranted =
          await androidPlugin?.requestNotificationsPermission() ?? false;

      await androidPlugin?.requestExactAlarmsPermission();

      return notificationGranted;
    }

    return false;
  }

  static Future<bool> hasPermission() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      final result = await iosPlugin?.checkPermissions();
      return result?.isEnabled ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      return await androidPlugin?.areNotificationsEnabled() ?? false;
    }

    return false;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      _notificationDetails(body),
      payload: payload,
    );
  }

  static Future<void> scheduleAll({
    required SubscriptionModel sub,
    int hour = _defaultHour,
    int minute = _defaultMinute,
  }) async {
    final subId = notificationIdFromString(sub.id);

    await cancelAll(subId);

    final nextBillDate = BillingLogic.calculateNextDate(sub);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final reminders = <_ReminderConfig>[
      _ReminderConfig(
        offsetDays: 3,
        idOffset: _NotificationOffset.threeDays,
        title: '${sub.name} renews in 3 days ❄️',
        body:
            '${sub.currency}${sub.amount.toStringAsFixed(2)} will be charged in 3 days.',
      ),
      _ReminderConfig(
        offsetDays: 1,
        idOffset: _NotificationOffset.oneDay,
        title: '${sub.name} renews tomorrow ❄️',
        body:
            '${sub.currency}${sub.amount.toStringAsFixed(2)} will be charged tomorrow.',
      ),
      _ReminderConfig(
        offsetDays: 0,
        idOffset: _NotificationOffset.dueDay,
        title: '${sub.name} is due today ❄️',
        body:
            '${sub.currency}${sub.amount.toStringAsFixed(2)} is being charged today.',
      ),
    ];

    int scheduledCount = 0;

    for (final reminder in reminders) {
      final targetDate = nextBillDate.subtract(
        Duration(days: reminder.offsetDays),
      );
      final targetDay = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );

      if (targetDay.isBefore(today)) continue;

      final fireTime = _resolveFireTime(
        targetDate: targetDate,
        hour: hour,
        minute: minute,
        now: now,
        today: today,
      );

      if (fireTime == null) continue;

      final success = await _scheduleResolved(
        id: _idFor(subId, reminder.idOffset),
        title: reminder.title,
        body: reminder.body,
        tzDate: fireTime,
        payload: sub.id,
      );

      if (success) scheduledCount++;
    }

    debugPrint('✅ Scheduled $scheduledCount notifications for ${sub.name}');
  }

  static tz.TZDateTime? _resolveFireTime({
    required DateTime targetDate,
    required int hour,
    required int minute,
    required DateTime now,
    required DateTime today,
  }) {
    final targetDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final scheduledDateTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      hour,
      minute,
    );

    if (scheduledDateTime.isAfter(now)) {
      return tz.TZDateTime.from(scheduledDateTime, tz.local);
    }

    final isToday = targetDay == today;

    if (isToday) {
      return tz.TZDateTime.from(now.add(const Duration(hours: 1)), tz.local);
    }

    return null;
  }

  static Future<bool> _scheduleResolved({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime tzDate,
    String? payload,
  }) async {
    try {
      await _plugin.cancel(id);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        _notificationDetails(body),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint('🔔 Scheduled "$title" at $tzDate');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to schedule notification $id: $e');
      return false;
    }
  }

  static NotificationDetails _notificationDetails(String body) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }

  static Future<void> requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestExactAlarmsPermission();

    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
      data: 'package:np.com.subzero',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    await intent.launch();
  }

  static Future<void> cancelAll(int subId) async {
    await Future.wait([
      _plugin.cancel(_idFor(subId, _NotificationOffset.threeDays)),
      _plugin.cancel(_idFor(subId, _NotificationOffset.oneDay)),
      _plugin.cancel(_idFor(subId, _NotificationOffset.dueDay)),
    ]);

    debugPrint('🗑 Cancelled notifications for subId: $subId');
  }

  static Future<void> cancelOne(int notificationId) {
    return _plugin.cancel(notificationId);
  }

  static Future<void> cancelAllPending() async {
    await _plugin.cancelAll();
    debugPrint('🗑 Cancelled all notifications');
  }

  static Future<List<PendingNotificationRequest>> getPending() {
    return _plugin.pendingNotificationRequests();
  }

  static Future<void> debugPrintPending() async {
    final pending = await getPending();

    debugPrint('📋 Pending notifications: ${pending.length}');

    for (final notification in pending) {
      debugPrint(
        '→ [${notification.id}] ${notification.title} | ${notification.payload}',
      );
    }
  }

  static int notificationIdFromString(String value) {
    int hash = 0;

    for (final codeUnit in value.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }

    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));

    return hash.abs();
  }

  static int _idFor(int subId, _NotificationOffset offset) {
    return subId + offset.value;
  }

  static void _onNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
  }
}

@pragma('vm:entry-point')
void _onBackgroundNotificationTap(NotificationResponse response) {
  debugPrint('🔔 Background notification tapped: ${response.payload}');
}

enum _NotificationOffset {
  threeDays(100000),
  oneDay(200000),
  dueDay(300000);

  final int value;

  const _NotificationOffset(this.value);
}

class _ReminderConfig {
  final int offsetDays;
  final _NotificationOffset idOffset;
  final String title;
  final String body;

  const _ReminderConfig({
    required this.offsetDays,
    required this.idOffset,
    required this.title,
    required this.body,
  });
}
