import 'package:equatable/equatable.dart';

class SubscriptionInfoState extends Equatable {
  final DateTime nextBillDate;
  final int daysUntilBilling;
  final double yearlyEquivalent;
  final double monthlyEquivalent;
  final double dailyEquivalent;

  const SubscriptionInfoState({
    required this.nextBillDate,
    required this.daysUntilBilling,
    required this.yearlyEquivalent,
    required this.monthlyEquivalent,
    required this.dailyEquivalent,
  });

  @override
  List<Object?> get props => [
    nextBillDate,
    daysUntilBilling,
    yearlyEquivalent,
    monthlyEquivalent,
    dailyEquivalent,
  ];
}
