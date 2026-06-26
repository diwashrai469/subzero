import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      onError: (_) {
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
          onError: (_) {
            emit(state.copyWith(notificationCount: 0));
          },
        );
  }

  Future<void> markAllNotificationsAsSeen() async {
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
      });
    }

    batch.update(userRef, {
      'hasUnreadNotifications': false,
      'unreadNotificationCount': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
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
    );
  }

  void _process(List<SubscriptionModel> subscriptions) {
    final today = _dateOnly(DateTime.now());

    final sortedSubscriptions = subscriptions.toList()
      ..sort((a, b) {
        final aNextDate = _getUpcomingDate(a, today);
        final bNextDate = _getUpcomingDate(b, today);

        final dateCompare = aNextDate.compareTo(bNextDate);

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
    DateTime nextDate = _dateOnly(subscription.nextBillDate);

    var safety = 0;

    while (nextDate.isBefore(today) && safety < 500) {
      nextDate = _addBillingCycle(nextDate, subscription.billingCycle);
      safety++;
    }

    return nextDate;
  }

  static DateTime _addBillingCycle(DateTime date, String cycle) {
    switch (cycle.toLowerCase().trim()) {
      case 'daily':
        return date.add(const Duration(days: 1));

      case 'weekly':
        return date.add(const Duration(days: 7));

      case 'fortnightly':
        return date.add(const Duration(days: 14));

      case 'monthly':
        return DateTime(date.year, date.month + 1, date.day);

      case 'quarterly':
        return DateTime(date.year, date.month + 3, date.day);

      case 'yearly':
        return DateTime(date.year + 1, date.month, date.day);

      default:
        return date;
    }
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
