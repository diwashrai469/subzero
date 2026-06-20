import 'package:subzero/feature/dashboard/model/subscription_model.dart';

class DashboardState {
  final bool loading;
  final List<SubscriptionModel> allSubs;
  final double monthlySpend;
  final double yearlySpend;
  final List<SubscriptionModel> biggestSubs;
  final double biggestSubPercentage;

  const DashboardState({
    this.loading = true,
    this.allSubs = const [],
    this.monthlySpend = 0,
    this.yearlySpend = 0,
    this.biggestSubs = const [],
    this.biggestSubPercentage = 0,
  });

  DashboardState copyWith({
    bool? loading,
    List<SubscriptionModel>? allSubs,
    double? monthlySpend,
    double? yearlySpend,
    List<SubscriptionModel>? biggestSubs,
    double? biggestSubPercentage,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      allSubs: allSubs ?? this.allSubs,
      monthlySpend: monthlySpend ?? this.monthlySpend,
      yearlySpend: yearlySpend ?? this.yearlySpend,
      biggestSubs: biggestSubs ?? this.biggestSubs,
      biggestSubPercentage: biggestSubPercentage ?? this.biggestSubPercentage,
    );
  }
}
