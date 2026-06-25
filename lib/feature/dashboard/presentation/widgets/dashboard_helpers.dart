import 'package:subzero/feature/dashboard/model/subscription_model.dart';

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

DateTime _addMonthsFromAnchor({
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

DateTime advanceByCycle(DateTime date, String cycle, {required int anchorDay}) {
  return switch (cycle) {
    'Weekly' => date.add(const Duration(days: 7)),
    'Fortnightly' => date.add(const Duration(days: 14)),
    'Quarterly' => _addMonthsFromAnchor(
      baseDate: date,
      monthsToAdd: 3,
      anchorDay: anchorDay,
    ),
    'Semi-annually' => _addMonthsFromAnchor(
      baseDate: date,
      monthsToAdd: 6,
      anchorDay: anchorDay,
    ),
    'Yearly' => _addMonthsFromAnchor(
      baseDate: date,
      monthsToAdd: 12,
      anchorDay: anchorDay,
    ),
    _ => _addMonthsFromAnchor(
      baseDate: date,
      monthsToAdd: 1,
      anchorDay: anchorDay,
    ),
  };
}

DateTime getNextUpcomingDate(SubscriptionModel sub) {
  final today = _dateOnly(DateTime.now());
  final firstBillDate = _dateOnly(sub.firstBillDate);
  final anchorDay = sub.firstBillDate.day;

  if (!firstBillDate.isBefore(today)) {
    return firstBillDate;
  }

  DateTime candidate = firstBillDate;
  int safety = 0;

  while (candidate.isBefore(today) && safety < 1200) {
    candidate = advanceByCycle(
      candidate,
      sub.billingCycle,
      anchorDay: anchorDay,
    );
    safety++;
  }

  return candidate;
}

String dueTextHelper(SubscriptionModel sub) {
  final today = _dateOnly(DateTime.now());
  final nextDate = getNextUpcomingDate(sub);
  final diff = nextDate.difference(today).inDays;

  if (diff == 0) return 'Due today';
  if (diff == 1) return 'Due tomorrow';
  if (diff < 0) return 'Overdue';

  return 'Due in ${diff}d';
}
