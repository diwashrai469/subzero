String currentMonthYear() {
  final now = DateTime.now();
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${now.day} ${months[now.month - 1]} ${now.year}';
}
