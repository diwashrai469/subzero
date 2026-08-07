import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/core/services/notification/analytics_service.dart';
import 'package:subzero/feature/dashboard/helper/dashboard_helper.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';

import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._firebase) : super(const DashboardState()) {
    load();
  }

  final SubscriptionFirebaseService _firebase;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscriptionStream;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userStream;

  Future<void> load() async {
    await _subscriptionStream?.cancel();
    await _userStream?.cancel();

    emit(state.copyWith(loading: true));

    _listenToSubscriptions();
    _listenToUserNotificationCount();
  }

  void _listenToSubscriptions() {
    _subscriptionStream = _firebase.subscriptionStream().listen(
      (snapshot) {
        final subscriptions = snapshot.docs.map(_mapSubscription).toList();

        _process(subscriptions);
      },
      onError: (error) {
        debugPrint('Failed to listen to subscriptions: $error');

        emit(state.copyWith(loading: false));
      },
    );
  }

  void _listenToUserNotificationCount() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(state.copyWith(notificationCount: 0));
      return;
    }

    _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen(
          (snapshot) {
            final data = snapshot.data();

            final unreadCount = _readInt(data?['unreadNotificationCount']);

            emit(state.copyWith(notificationCount: unreadCount));
          },
          onError: (error) {
            debugPrint('Failed to listen to notification count: $error');

            emit(state.copyWith(notificationCount: 0));
          },
        );
  }

  Future<void> markAllNotificationsAsSeen() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final firestore = FirebaseFirestore.instance;

      final userRef = firestore.collection('users').doc(user.uid);

      final unreadNotifications = await userRef
          .collection('notifications')
          .where('isSeen', isEqualTo: false)
          .get();

      final batch = firestore.batch();

      for (final document in unreadNotifications.docs) {
        batch.update(document.reference, {
          'isSeen': true,
          'seenAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      batch.set(userRef, {
        'hasUnreadNotifications': false,
        'unreadNotificationCount': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      final isBadgeSupported =
          await FlutterAppBadgeControl.isAppBadgeSupported();

      if (isBadgeSupported) {
        await FlutterAppBadgeControl.removeBadge();
      }
    } catch (error) {
      debugPrint('Failed to mark notifications as seen: $error');
    }
  }

  SubscriptionModel _mapSubscription(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    return SubscriptionModel(
      id: document.id,
      name: data['name'] as String? ?? '',
      amount: _readDouble(data['amount']),
      totalTillDate: _readDouble(data['totalTillDate']),
      currency: data['currency'] as String? ?? '\$',
      currencyCode: data['currencyCode'] as String? ?? 'USD',
      firstBillDate: _readTimestamp(data['firstBillDate']),
      nextBillDate: _readTimestamp(data['nextBillDate']),
      billingCycle: data['billingCycle'] as String? ?? '',
      category: data['category'] as String? ?? '',
      cancelUrl: data['cancelUrl'] as String?,
      reminderDays: _readReminderDays(data['reminderDays']),
      lastReminderType: data['lastReminderType'] as String?,
      lastReminderId: data['lastReminderId'] as String?,
      lastReminderSentAt: _readNullableTimestamp(data['lastReminderSentAt']),
      lastChargedAt: _readNullableTimestamp(data['lastChargedAt']),
    );
  }

  void _process(List<SubscriptionModel> subscriptions) {
    final helper = DashboardHelper();

    final sortedSubscriptions = List<SubscriptionModel>.from(subscriptions)
      ..sort((first, second) {
        final firstDueDate = helper.effectiveDueDate(first);
        final secondDueDate = helper.effectiveDueDate(second);

        final dateComparison = firstDueDate.compareTo(secondDueDate);

        if (dateComparison != 0) {
          return dateComparison;
        }

        return first.name.toLowerCase().compareTo(second.name.toLowerCase());
      });

    final monthlySpend = AnalyticsService.monthlyLeakage(sortedSubscriptions);

    final yearlySpend = AnalyticsService.yearlyWaste(sortedSubscriptions);

    final highestAmount = _getHighestAmount(sortedSubscriptions);

    final biggestSubscriptions = highestAmount == 0
        ? <SubscriptionModel>[]
        : sortedSubscriptions
              .where((subscription) => subscription.amount == highestAmount)
              .toList();

    final biggestSubscriptionPercentage =
        monthlySpend == 0 || highestAmount == 0
        ? 0.0
        : (highestAmount / monthlySpend) * 100;

    emit(
      state.copyWith(
        loading: false,
        allSubs: sortedSubscriptions,
        monthlySpend: monthlySpend,
        yearlySpend: yearlySpend,
        biggestSubs: biggestSubscriptions,
        biggestSubPercentage: biggestSubscriptionPercentage,
      ),
    );
  }

  static double _getHighestAmount(List<SubscriptionModel> subscriptions) {
    if (subscriptions.isEmpty) {
      return 0;
    }

    return subscriptions
        .map((subscription) => subscription.amount)
        .reduce((current, next) => current > next ? current : next);
  }

  static List<int> _readReminderDays(dynamic value) {
    if (value is Iterable) {
      return value.whereType<num>().map((item) => item.toInt()).toList();
    }

    return const [1];
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }

  static DateTime? _readNullableTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  static double _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
