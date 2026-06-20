/// Formats a [DateTime] as `d-M-yyyy`.
String formatDate(DateTime date) => '${date.day}-${date.month}-${date.year}';

/// Formats a [DateTime] as `d/M/yyyy`.
String formatDateSlash(DateTime date) =>
    '${date.day}/${date.month}/${date.year}';

/// Capitalises the first letter of [s].
String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
