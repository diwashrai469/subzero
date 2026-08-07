class SubscriptionModel {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String currencyCode;
  final DateTime firstBillDate;
  final DateTime nextBillDate;
  final String billingCycle;
  final String category;
  final String? cancelUrl;
  final double totalTillDate;
  final DateTime? lastChargedAt;

  final List<int> reminderDays;

  final String? lastReminderType;
  final String? lastReminderId;
  final DateTime? lastReminderSentAt;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.currencyCode,
    required this.firstBillDate,
    required this.nextBillDate,
    required this.billingCycle,
    required this.category,
    required this.totalTillDate,
    this.cancelUrl,
    this.reminderDays = const [1],
    this.lastReminderType,
    this.lastReminderId,
    this.lastReminderSentAt,
    this.lastChargedAt,
  });

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? currency,
    String? currencyCode,
    DateTime? firstBillDate,
    DateTime? nextBillDate,
    String? billingCycle,
    String? category,
    String? cancelUrl,
    double? totalTillDate,
    List<int>? reminderDays,
    String? lastReminderType,
    String? lastReminderId,
    DateTime? lastReminderSentAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      currencyCode: currencyCode ?? this.currencyCode,
      firstBillDate: firstBillDate ?? this.firstBillDate,
      nextBillDate: nextBillDate ?? this.nextBillDate,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      cancelUrl: cancelUrl ?? this.cancelUrl,
      totalTillDate: totalTillDate ?? this.totalTillDate,
      reminderDays: reminderDays ?? this.reminderDays,
      lastReminderType: lastReminderType ?? this.lastReminderType,
      lastReminderId: lastReminderId ?? this.lastReminderId,
      lastReminderSentAt: lastReminderSentAt ?? this.lastReminderSentAt,
      lastChargedAt: lastChargedAt ?? lastChargedAt,
    );
  }
}
