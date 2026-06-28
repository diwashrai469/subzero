// ── Category model ─────────────────────────────────────────────
import 'dart:ui';

class SubscriptionCategoryModel {
  final String label;
  final String emoji;
  final Color iconColor;
  final Color bgColor;

  const SubscriptionCategoryModel({
    required this.label,
    required this.emoji,
    required this.iconColor,
    required this.bgColor,
  });
}
