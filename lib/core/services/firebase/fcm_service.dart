import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';

class FCMService {
  FCMService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static bool _listenersRegistered = false;

  static Future<void> init() async {
    await requestPermission();

    _registerListeners();

    await _handleInitialMessage();

    // Important:
    // Do NOT save FCM token here.
    // At app start, FirebaseAuth.currentUser may still be null.
  }

  static Future<void> saveTokenForCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('⚠️ FCM token not saved because user is not signed in yet');
        return;
      }

      if (Platform.isIOS) {
        final apnsReady = await _waitForAPNSToken();

        if (!apnsReady) {
          debugPrint('⚠️ APNS token not ready yet');
          return;
        }
      }

      final token = await _messaging.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token is null or empty');
        return;
      }

      await locator<SubscriptionFirebaseService>().saveFcmToken(token);

      debugPrint('✅ FCM token saved for user: ${user.uid}');
    } catch (e) {
      debugPrint('❌ FCM token error: $e');
    }
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

  static Future<bool> _waitForAPNSToken() async {
    for (var i = 0; i < 10; i++) {
      final apnsToken = await _messaging.getAPNSToken();

      if (apnsToken != null) {
        debugPrint('🍎 APNS token received');
        return true;
      }

      await Future<void>.delayed(const Duration(seconds: 1));
    }

    return false;
  }

  static void _registerListeners() {
    if (_listenersRegistered) return;

    _listenersRegistered = true;

    _listenTokenRefresh();
    _listenForegroundMessages();
    _listenNotificationOpened();
  }

  static void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint('⚠️ Refreshed FCM token not saved because user is null');
        return;
      }

      await locator<SubscriptionFirebaseService>().saveFcmToken(token);

      debugPrint('🔄 FCM token refreshed and saved');
    });
  }

  static void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 FCM received while app is open');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');

      // Do not call local notification here if Firebase notification payload
      // already shows system notifications in background/terminated state.
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
