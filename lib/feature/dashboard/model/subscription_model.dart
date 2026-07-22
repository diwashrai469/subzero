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

  final String? lastReminderType;
  final String? lastReminderId;
  final DateTime? lastReminderSentAt;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.firstBillDate,
    required this.nextBillDate,
    required this.billingCycle,
    required this.category,
    this.cancelUrl,
    this.lastReminderType,
    this.lastReminderId,
    this.lastReminderSentAt,
    required this.totalTillDate,
    required this.currencyCode,
  });

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? currency,
    DateTime? firstBillDate,
    DateTime? nextBillDate,
    String? billingCycle,
    String? category,
    String? cancelUrl,
    String? lastReminderType,
    String? lastReminderId,
    DateTime? lastReminderSentAt,
    double? totalTillDate,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      firstBillDate: firstBillDate ?? this.firstBillDate,
      nextBillDate: nextBillDate ?? this.nextBillDate,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      cancelUrl: cancelUrl ?? this.cancelUrl,
      lastReminderType: lastReminderType ?? this.lastReminderType,
      lastReminderId: lastReminderId ?? this.lastReminderId,
      lastReminderSentAt: lastReminderSentAt ?? this.lastReminderSentAt,
      totalTillDate: totalTillDate ?? this.totalTillDate,
      currencyCode: '',
    );
  }
}
