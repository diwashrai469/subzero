import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/core/services/notification/analytics_service.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';

import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final SubscriptionFirebaseService _firebase;
  StreamSubscription? _sub;

  DashboardCubit(this._firebase) : super(const DashboardState()) {
    load();
  }

  Future<void> load() async {
    final uid = await _firebase.userId;

    await _sub?.cancel();

    _sub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .snapshots()
        .listen((snapshot) {
          final subs = snapshot.docs.map((doc) {
            final data = doc.data();

            return SubscriptionModel(
              id: doc.id,
              name: data['name'] ?? '',
              amount: (data['amount'] ?? 0).toDouble(),
              currency: data['currency'] ?? '\$',
              firstBillDate: _readTimestamp(data['firstBillDate']),
              nextBillDate: _readTimestamp(data['nextBillDate']),
              billingCycle: data['billingCycle'] ?? '',
              category: data['category'] ?? '',
            );
          }).toList();

          _process(subs);
        });
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }

  void _process(List<SubscriptionModel> subs) {
    final today = _dateOnly(DateTime.now());

    final sortedSubs = subs.toList()
      ..sort((a, b) {
        final aNext = _getUpcomingDate(a, today);
        final bNext = _getUpcomingDate(b, today);

        final dateCompare = aNext.compareTo(bNext);

        if (dateCompare != 0) return dateCompare;

        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    final monthly = AnalyticsService.monthlyLeakage(sortedSubs);
    final yearly = AnalyticsService.yearlyWaste(sortedSubs);

    final highestAmount = sortedSubs.isEmpty
        ? 0.0
        : sortedSubs
              .map((sub) => sub.amount)
              .reduce((current, next) => current > next ? current : next);

    final biggestSubs = highestAmount == 0
        ? <SubscriptionModel>[]
        : sortedSubs.where((sub) => sub.amount == highestAmount).toList();

    final biggestSubPercentage = monthly == 0 || highestAmount == 0
        ? 0.0
        : (highestAmount / monthly) * 100;

    emit(
      state.copyWith(
        loading: false,
        allSubs: sortedSubs,
        monthlySpend: monthly,
        yearlySpend: yearly,
        biggestSubs: biggestSubs,
        biggestSubPercentage: biggestSubPercentage,
      ),
    );
  }

  static DateTime _getUpcomingDate(SubscriptionModel sub, DateTime today) {
    DateTime next = _dateOnly(sub.nextBillDate);

    int safety = 0;

    while (next.isBefore(today) && safety < 500) {
      next = _addBillingCycle(next, sub.billingCycle);
      safety++;
    }

    return next;
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

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
