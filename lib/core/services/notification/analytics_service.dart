import 'package:subzero/feature/dashboard/model/subscription_model.dart';

class AnalyticsService {
  static double monthlyLeakage(List<SubscriptionModel> subs) {
    double total = 0;

    for (var sub in subs) {
      switch (sub.billingCycle.toLowerCase()) {
        case "daily":
          total += sub.amount * 30;
          break;

        case "weekly":
          total += sub.amount * 4.33;
          break;

        case "fortnightly":
        case "biweekly":
          total += sub.amount * 2.17;
          break;

        case "monthly":
          total += sub.amount;
          break;

        case "quarterly":
          total += sub.amount / 3;
          break;

        case "yearly":
          total += sub.amount / 12;
          break;
      }
    }

    return total;
  }

  static double yearlyWaste(List<SubscriptionModel> subs) {
    double total = 0;

    for (var sub in subs) {
      switch (sub.billingCycle.toLowerCase()) {
        case "daily":
          total += sub.amount * 365;
          break;

        case "weekly":
          total += sub.amount * 52;
          break;

        case "fortnightly":
        case "biweekly":
          total += sub.amount * 26;
          break;

        case "monthly":
          total += sub.amount * 12;
          break;

        case "quarterly":
          total += sub.amount * 4;
          break;

        case "yearly":
          total += sub.amount;
          break;
      }
    }

    return total;
  }
}
