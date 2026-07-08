import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:injectable/injectable.dart';

import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/core/services/notification/analytics_service.dart';
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

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final unreadNotifications = await userRef
          .collection('notifications')
          .where('isSeen', isEqualTo: false)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in unreadNotifications.docs) {
        batch.update(doc.reference, {
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
    } catch (e) {
      debugPrint('Failed to mark notifications as seen: $e');
    }
  }

  SubscriptionModel _mapSubscription(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return SubscriptionModel(
      id: doc.id,
      name: data['name'] ?? '',
      amount: _readDouble(data['amount']),
      currency: data['currency'] ?? '\$',
      firstBillDate: _readTimestamp(data['firstBillDate']),
      nextBillDate: _readTimestamp(data['nextBillDate']),
      billingCycle: data['billingCycle'] ?? '',
      category: data['category'] ?? '',
      cancelUrl: data['cancelUrl'],
      lastReminderType: data['lastReminderType'],
      lastReminderId: data['lastReminderId'],
      lastReminderSentAt: _readNullableTimestamp(data['lastReminderSentAt']),
    );
  }

  void _process(List<SubscriptionModel> subscriptions) {
    final today = _dateOnly(DateTime.now());

    final sortedSubscriptions = subscriptions.toList()
      ..sort((a, b) {
        final aUpcomingDate = _getUpcomingDate(a, today);
        final bUpcomingDate = _getUpcomingDate(b, today);

        final dateCompare = aUpcomingDate.compareTo(bUpcomingDate);

        if (dateCompare != 0) return dateCompare;

        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    final monthlySpend = AnalyticsService.monthlyLeakage(sortedSubscriptions);
    final yearlySpend = AnalyticsService.yearlyWaste(sortedSubscriptions);

    final highestAmount = _getHighestAmount(sortedSubscriptions);

    final biggestSubscriptions = highestAmount == 0
        ? <SubscriptionModel>[]
        : sortedSubscriptions
              .where((subscription) => subscription.amount == highestAmount)
              .toList();

    final biggestSubPercentage = monthlySpend == 0 || highestAmount == 0
        ? 0.0
        : (highestAmount / monthlySpend) * 100;

    emit(
      state.copyWith(
        loading: false,
        allSubs: sortedSubscriptions,
        monthlySpend: monthlySpend,
        yearlySpend: yearlySpend,
        biggestSubs: biggestSubscriptions,
        biggestSubPercentage: biggestSubPercentage,
      ),
    );
  }

  static double _getHighestAmount(List<SubscriptionModel> subscriptions) {
    if (subscriptions.isEmpty) return 0.0;

    return subscriptions
        .map((subscription) => subscription.amount)
        .reduce((current, next) => current > next ? current : next);
  }

  static DateTime _getUpcomingDate(
    SubscriptionModel subscription,
    DateTime today,
  ) {
    final nextBillDate = _dateOnly(subscription.nextBillDate);

    /*
      Important case:

      Your backend may send today's reminder and then immediately move
      nextBillDate to the next billing cycle.

      Example:
      Spotify was due today.
      Backend sends today's reminder.
      Backend changes nextBillDate to next month.

      Without this check, the UI would instantly move Spotify away from today.
      This keeps it sorted as "today" until the day ends.
    */
    if (_wasTodayReminderSentToday(subscription, today) &&
        nextBillDate.isAfter(today)) {
      return today;
    }

    /*
      Normal case:

      If nextBillDate is today or in the future, use it directly.
      Because we already removed the time, sorting is clean.
    */
    if (!nextBillDate.isBefore(today)) {
      return nextBillDate;
    }

    /*
      Safety case:

      If nextBillDate is old/past, calculate the next real upcoming billing date
      using the billing cycle.

      This protects you if Firestore has outdated nextBillDate values.
    */
    DateTime calculatedDate = nextBillDate;

    while (calculatedDate.isBefore(today)) {
      calculatedDate = _addBillingCycle(
        calculatedDate,
        subscription.billingCycle,
      );
    }

    return calculatedDate;
  }

  static DateTime _addBillingCycle(DateTime date, String billingCycle) {
    final cycle = billingCycle.toLowerCase().trim();

    if (cycle.contains('week')) {
      return date.add(const Duration(days: 7));
    }

    if (cycle.contains('fortnight')) {
      return date.add(const Duration(days: 14));
    }

    if (cycle.contains('month')) {
      return _addMonths(date, 1);
    }

    if (cycle.contains('quarter')) {
      return _addMonths(date, 3);
    }

    if (cycle.contains('semi')) {
      return _addMonths(date, 6);
    }

    if (cycle.contains('year')) {
      return _addMonths(date, 12);
    }

    return _addMonths(date, 1);
  }

  static DateTime _addMonths(DateTime date, int monthsToAdd) {
    final targetMonthDate = DateTime(date.year, date.month + monthsToAdd, 1);

    final lastDayOfTargetMonth = DateTime(
      targetMonthDate.year,
      targetMonthDate.month + 1,
      0,
    ).day;

    final safeDay = date.day > lastDayOfTargetMonth
        ? lastDayOfTargetMonth
        : date.day;

    return DateTime(targetMonthDate.year, targetMonthDate.month, safeDay);
  }

  static bool _wasTodayReminderSentToday(
    SubscriptionModel subscription,
    DateTime today,
  ) {
    final lastReminderSentAt = subscription.lastReminderSentAt;

    if (lastReminderSentAt == null) return false;

    final sentDate = _dateOnly(lastReminderSentAt);

    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final expectedReminderId = 'today_$todayKey';

    return subscription.lastReminderType == 'today' &&
        subscription.lastReminderId == expectedReminderId &&
        sentDate == today;
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return _dateOnly(value.toDate());
    }

    if (value is DateTime) {
      return _dateOnly(value);
    }

    return _dateOnly(DateTime.now());
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
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
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

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Future<void> close() async {
    await _subscriptionStream?.cancel();
    await _userStream?.cancel();

    return super.close();
  }
}
