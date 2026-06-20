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
    final nextBill = _computeNextBillDate(sub);
    final today = _onlyDate(DateTime.now());
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
  static DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _computeNextBillDate(SubscriptionModel sub) {
    final today = _onlyDate(DateTime.now());
    DateTime billDate = _onlyDate(sub.firstBillDate);

    // Advance until we reach a date >= today (same logic as dashboard)
    while (billDate.isBefore(today)) {
      billDate = _advanceByBillingCycle(billDate, sub.billingCycle);
    }

    return billDate;
  }

  static DateTime _advanceByBillingCycle(DateTime date, String cycle) {
    switch (cycle.toLowerCase()) {
      case 'weekly':
        return date.add(const Duration(days: 7));
      case 'quarterly':
        return DateTime(date.year, date.month + 3, date.day);
      case 'yearly':
      case 'annual':
        return DateTime(date.year + 1, date.month, date.day);
      case 'monthly':
      default:
        return DateTime(date.year, date.month + 1, date.day);
    }
  }

  // ─────────────────────────────────────────────
  // Cost helpers
  // ─────────────────────────────────────────────
  static double _computeYearlyEquivalent(SubscriptionModel sub) {
    switch (sub.billingCycle.toLowerCase()) {
      case 'weekly':
        return sub.amount * 52;
      case 'quarterly':
        return sub.amount * 4;
      case 'yearly':
      case 'annual':
        return sub.amount;
      case 'monthly':
      default:
        return sub.amount * 12;
    }
  }

  // ─────────────────────────────────────────────
  // UI helpers (pure functions, safe to expose)
  // ─────────────────────────────────────────────
  static Color urgencyColor(int daysUntilBilling) {
    if (daysUntilBilling == 0) return const Color(0xFFEF4444);
    if (daysUntilBilling <= 3) return const Color(0xFFF97316);
    return const Color(0xFF22C55E);
  }

  static String billingMessage(int days) {
    if (days == 0) return 'Billing today';
    if (days <= 3) return 'Billing very soon';
    if (days <= 7) return 'Billing this week';
    return 'Next billing in $days days';
  }

  // ─────────────────────────────────────────────
  // Refresh (e.g. after editing the subscription)
  // ─────────────────────────────────────────────
  void refresh(SubscriptionModel updated) => emit(_buildState(updated));
}
