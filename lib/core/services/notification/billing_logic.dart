import 'package:subzero/feature/dashboard/model/subscription_model.dart';

class BillingLogic {
  static DateTime calculateNextDate(SubscriptionModel sub) {
    DateTime nextDate = sub.nextBillDate;
    final now = DateTime.now();

    while (nextDate.isBefore(now)) {
      switch (sub.billingCycle.toLowerCase()) {
        case "daily":
          nextDate = nextDate.add(const Duration(days: 1));
          break;

        case "weekly":
          nextDate = nextDate.add(const Duration(days: 7));
          break;

        case "fortnightly":
        case "biweekly":
          nextDate = nextDate.add(const Duration(days: 14));
          break;

        case "monthly":
          nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
          break;

        case "quarterly":
          nextDate = DateTime(nextDate.year, nextDate.month + 3, nextDate.day);
          break;

        case "yearly":
          nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
          break;

        case "custom":
        default:
          nextDate = nextDate.add(const Duration(days: 30));
      }
    }

    return nextDate;
  }
}
