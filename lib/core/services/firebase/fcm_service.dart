import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';

class FCMService {
  FCMService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await requestPermission();
    await _saveToken();

    _listenTokenRefresh();
    _listenForegroundMessages();
    _listenNotificationOpened();

    await _handleInitialMessage();
  }

  static Future<bool> hasNotificationPermission() async {
    final settings = await _messaging.getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  static Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  static Future<void> _saveToken() async {
    try {
      if (Platform.isIOS) {
        final apnsReady = await _waitForAPNSToken();

        if (!apnsReady) {
          debugPrint('⚠️ APNS token not ready yet');
          return;
        }
      }

      final token = await _messaging.getToken();

      if (token == null) {
        debugPrint('⚠️ FCM token is null');
        return;
      }

      await locator<SubscriptionFirebaseService>().saveFcmToken(token);

      debugPrint('✅ FCM token saved');
    } catch (e) {
      debugPrint('❌ FCM token error: $e');
    }
  }

  static Future<bool> _waitForAPNSToken() async {
    for (int i = 0; i < 10; i++) {
      final apnsToken = await _messaging.getAPNSToken();

      if (apnsToken != null) {
        debugPrint('🍎 APNS token received');
        return true;
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    return false;
  }

  static void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) async {
      await locator<SubscriptionFirebaseService>().saveFcmToken(token);
      debugPrint('🔄 FCM token refreshed and saved');
    });
  }

  static void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 FCM received while app is open');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');

      // Important:
      // Do not call local notification here.
      // This prevents duplicate notifications.
    });
  }

  static void _listenNotificationOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 App opened from notification');
      debugPrint('Sub ID: ${message.data['subId']}');
    });
  }

  static Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message != null) {
      debugPrint('🚀 App opened from terminated notification');
      debugPrint('Sub ID: ${message.data['subId']}');
    }
  }
}
