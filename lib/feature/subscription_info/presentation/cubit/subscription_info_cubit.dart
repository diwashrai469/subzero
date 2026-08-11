import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/subscription_info/presentation/cubit/subscription_info_state.dart';

@injectable
class SubscriptionInfoCubit extends Cubit<SubscriptionInfoState> {
  final SubscriptionModel sub;

  SubscriptionInfoCubit(@factoryParam this.sub) : super(_buildState(sub));

  // ─────────────────────────────────────────────
  // Factory: compute initial state from model
  // ─────────────────────────────────────────────
  static SubscriptionInfoState _buildState(SubscriptionModel sub) {
    final today = _onlyDate(DateTime.now());
    final nextBill = _computeNextBillDate(sub);
    final days = nextBill.difference(today).inDays;
    final yearly = _computeYearlyEquivalent(sub);

    return SubscriptionInfoState(
      nextBillDate: nextBill,
      daysUntilBilling: days,
      yearlyEquivalent: yearly,
      monthlyEquivalent: yearly / 12,
      dailyEquivalent: yearly / 365,
    );
  }

  // ─────────────────────────────────────────────
  // Date helpers
  // ─────────────────────────────────────────────

  static DateTime _onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static DateTime _addMonthsFromAnchor({
    required DateTime baseDate,
    required int monthsToAdd,
    required int anchorDay,
  }) {
    final rawMonth = baseDate.month + monthsToAdd;
    final year = baseDate.year + ((rawMonth - 1) ~/ 12);
    final month = ((rawMonth - 1) % 12) + 1;
    final maxDay = _daysInMonth(year, month);
    final day = anchorDay.clamp(1, maxDay);

    return DateTime(year, month, day);
  }

  static DateTime _computeNextBillDate(SubscriptionModel sub) {
    final today = _onlyDate(DateTime.now());
    final firstBillDate = _onlyDate(sub.firstBillDate);
    final anchorDay = sub.firstBillDate.day;

    if (!firstBillDate.isBefore(today)) {
      return firstBillDate;
    }

    DateTime candidate = firstBillDate;
    int safety = 0;

    while (candidate.isBefore(today) && safety < 1200) {
      candidate = _advanceByBillingCycle(
        candidate,
        sub.billingCycle,
        anchorDay: anchorDay,
      );

      safety++;
    }

    return candidate;
  }

  static DateTime _advanceByBillingCycle(
    DateTime date,
    String cycle, {
    required int anchorDay,
  }) {
    switch (cycle.trim().toLowerCase()) {
      case 'weekly':
        return date.add(const Duration(days: 7));

      case 'fortnightly':
        return date.add(const Duration(days: 14));

      case 'quarterly':
        return _addMonthsFromAnchor(
          baseDate: date,
          monthsToAdd: 3,
          anchorDay: anchorDay,
        );

      case 'semi-annually':
      case 'semi annually':
      case 'semiannual':
      case 'semi-annual':
        return _addMonthsFromAnchor(
          baseDate: date,
          monthsToAdd: 6,
          anchorDay: anchorDay,
        );

      case 'yearly':
      case 'annual':
      case 'annually':
        return _addMonthsFromAnchor(
          baseDate: date,
          monthsToAdd: 12,
          anchorDay: anchorDay,
        );

      case 'monthly':
      default:
        return _addMonthsFromAnchor(
          baseDate: date,
          monthsToAdd: 1,
          anchorDay: anchorDay,
        );
    }
  }

  // ─────────────────────────────────────────────
  // Cost helpers
  // ─────────────────────────────────────────────

  static double _computeYearlyEquivalent(SubscriptionModel sub) {
    switch (sub.billingCycle.trim().toLowerCase()) {
      case 'weekly':
        return sub.amount * 52;

      case 'fortnightly':
        return sub.amount * 26;

      case 'quarterly':
        return sub.amount * 4;

      case 'semi-annually':
      case 'semi annually':
      case 'semiannual':
      case 'semi-annual':
        return sub.amount * 2;

      case 'yearly':
      case 'annual':
      case 'annually':
        return sub.amount;

      case 'monthly':
      default:
        return sub.amount * 12;
    }
  }

  // ─────────────────────────────────────────────
  // UI helpers
  // ─────────────────────────────────────────────

  static Color urgencyColor(int daysUntilBilling) {
    if (daysUntilBilling < 0) {
      return const Color(0xFFDC2626);
    }

    if (daysUntilBilling == 0) {
      return const Color(0xFFEF4444);
    }

    if (daysUntilBilling <= 3) {
      return const Color(0xFFF97316);
    }

    return const Color(0xFF22C55E);
  }
}
