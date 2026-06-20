// ── Date helpers ──────────────────────────────────────────────

import 'package:subzero/feature/dashboard/model/subscription_model.dart';

DateTime advanceByCycle(DateTime date, String cycle) {
  return switch (cycle) {
    'Weekly' => date.add(const Duration(days: 7)),
    'Fortnightly' => date.add(const Duration(days: 14)),
    'Semi-annually' => DateTime(date.year, date.month + 6, date.day),
    'Yearly' => DateTime(date.year + 1, date.month, date.day),
    _ => DateTime(date.year, date.month + 1, date.day),
  };
}

DateTime _getNextUpcomingDate(SubscriptionModel sub) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime candidate = DateTime(
    sub.firstBillDate.year,
    sub.firstBillDate.month,
    sub.firstBillDate.day,
  );

  if (!candidate.isBefore(today)) return candidate;

  int safety = 0;
  while (candidate.isBefore(today) && safety < 1000) {
    candidate = advanceByCycle(candidate, sub.billingCycle);
    safety++;
  }

  return candidate;
}

String dueTextHelper(SubscriptionModel sub) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final next = _getNextUpcomingDate(sub);
  final diff = next.difference(today).inDays;

  if (diff == 0) return 'Due today';
  if (diff == 1) return 'Due tomorrow';
  if (diff < 0) return 'Overdue';
  return 'Due in ${diff}d';
}
