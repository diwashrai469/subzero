class AddSubState {
  final String name;
  final String amount;
  final String currency;
  final String billingCycle;
  final String category;
  final DateTime? firstBillDate;
  final bool isLoading;
  final double totalTillDate;

  const AddSubState({
    this.name = '',
    this.amount = '',
    this.currency = 'USD',
    this.billingCycle = 'Monthly',
    this.category = 'Others',
    this.totalTillDate = 0.0,
    this.firstBillDate,
    this.isLoading = false,
  });

  AddSubState copyWith({
    String? name,
    String? amount,
    String? currency,
    String? billingCycle,
    String? category,
    DateTime? firstBillDate,
    bool? isLoading,
    double? totalTillDate,
  }) {
    return AddSubState(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      firstBillDate: firstBillDate ?? this.firstBillDate,
      isLoading: isLoading ?? this.isLoading,
      totalTillDate: totalTillDate ?? this.totalTillDate,
    );
  }
}
