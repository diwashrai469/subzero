import 'package:flutter/material.dart';

class NotificationColors {
  static const background = Color(0xFFF7F7F8);
  static const surface = Colors.white;
  static const ink = Color(0xFF0A0A0A);
  static const subtext = Color(0xFF8A8A8E);
  static const divider = Color(0xFFE8E8EA);
}

String month(int m) => const [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][m];
