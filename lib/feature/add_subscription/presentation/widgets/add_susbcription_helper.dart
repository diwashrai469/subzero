DateTime calcNextBillDate(DateTime first, String cycle) {
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final chosenDay = DateTime(first.year, first.month, first.day);

  // If user picked today or a future date, store it as-is — do NOT advance.
  if (!chosenDay.isBefore(today)) return first;

  // Chosen date is in the past — advance one cycle at a time until
  // we reach today or later.
  DateTime next = first;
  while (next.isBefore(today)) {
    next = _advanceOneCycle(next, cycle);
  }
  return next;
}

DateTime _advanceOneCycle(DateTime from, String cycle) {
  switch (cycle) {
    case 'Weekly':
      return from.add(const Duration(days: 7));

    case 'Fortnightly':
      return from.add(const Duration(days: 14));

    case 'Monthly':
      final nextMonth = from.month + 1;
      final nextYear = from.year + (nextMonth > 12 ? 1 : 0);
      final clampedMonth = nextMonth > 12 ? 1 : nextMonth;
      final maxDay = _daysInMonth(nextYear, clampedMonth);
      return DateTime(nextYear, clampedMonth, from.day.clamp(1, maxDay));

    case 'Quarterly':
      final nextMonth = from.month + 3;
      final nextYear = from.year + ((nextMonth - 1) ~/ 12);
      final clampedMonth = ((nextMonth - 1) % 12) + 1;
      final maxDay = _daysInMonth(nextYear, clampedMonth);
      return DateTime(nextYear, clampedMonth, from.day.clamp(1, maxDay));

    case 'Semi-annually':
      final nextMonth = from.month + 6;
      final nextYear = from.year + ((nextMonth - 1) ~/ 12);
      final clampedMonth = ((nextMonth - 1) % 12) + 1;
      final maxDay = _daysInMonth(nextYear, clampedMonth);
      return DateTime(nextYear, clampedMonth, from.day.clamp(1, maxDay));

    case 'Yearly':
      final maxDay = _daysInMonth(from.year + 1, from.month);
      return DateTime(from.year + 1, from.month, from.day.clamp(1, maxDay));

    default:
      final nextMonth = from.month + 1;
      final nextYear = from.year + (nextMonth > 12 ? 1 : 0);
      final clampedMonth = nextMonth > 12 ? 1 : nextMonth;
      final maxDay = _daysInMonth(nextYear, clampedMonth);
      return DateTime(nextYear, clampedMonth, from.day.clamp(1, maxDay));
  }
}

int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;
