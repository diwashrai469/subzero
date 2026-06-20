class SubscriptionModel {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final DateTime firstBillDate;
  final DateTime nextBillDate;
  final String billingCycle;
  final String category;
  final String? cancelUrl;

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
    );
  }
}
