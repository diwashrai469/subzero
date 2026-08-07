import 'package:firebase_auth/firebase_auth.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';

class DashboardHelper {
  String signedInText(User? user) {
    final providers =
        user?.providerData.map((provider) => provider.providerId) ?? [];

    if (providers.contains('google.com')) {
      return 'Signed in with Google';
    }

    if (providers.contains('apple.com')) {
      return 'Signed in with Apple';
    }

    return 'Signed in securely';
  }

  Map<String, double> spendByCurrency(
    List<SubscriptionModel> subscriptions, {
    required bool yearly,
  }) {
    final totals = <String, double>{};

    for (final subscription in subscriptions) {
      final currency = subscription.currency.trim().isEmpty
          ? 'AUD'
          : subscription.currency.trim().toUpperCase();

      final amount = _equivalentAmount(subscription, yearly: yearly);

      totals.update(
        currency,
        (current) => current + amount,
        ifAbsent: () => amount,
      );
    }

    return totals;
  }

  double _equivalentAmount(
    SubscriptionModel subscription, {
    required bool yearly,
  }) {
    final amount = subscription.amount;

    final yearlyAmount = switch (subscription.billingCycle
        .trim()
        .toLowerCase()) {
      'daily' => amount * 365,
      'weekly' => amount * 52,
      'fortnightly' => amount * 26,
      'monthly' => amount * 12,
      'quarterly' => amount * 4,
      'semi-annually' ||
      'semi annually' ||
      'semiannual' ||
      'semi-annual' => amount * 2,
      'yearly' => amount,
      _ => amount * 12,
    };

    return yearly ? yearlyAmount : yearlyAmount / 12;
  }

  DateTime dateOnly(DateTime date) {
    final localDate = date.toLocal();

    return DateTime(localDate.year, localDate.month, localDate.day);
  }

  bool wasChargedToday(SubscriptionModel subscription) {
    final lastChargedAt = subscription.lastChargedAt;

    if (lastChargedAt == null) {
      return false;
    }

    final today = dateOnly(DateTime.now());
    final chargedDate = dateOnly(lastChargedAt);

    return chargedDate == today;
  }

  DateTime effectiveDueDate(SubscriptionModel subscription) {
    final today = dateOnly(DateTime.now());

    if (wasChargedToday(subscription)) {
      return today;
    }

    return dateOnly(subscription.nextBillDate);
  }

  String dueTextHelper(SubscriptionModel subscription) {
    final today = dateOnly(DateTime.now());
    final dueDate = effectiveDueDate(subscription);
    final difference = dueDate.difference(today).inDays;

    if (difference == 0) {
      return 'Due today';
    }

    if (difference == 1) {
      return 'Due tomorrow';
    }

    if (difference < 0) {
      return 'Overdue';
    }

    return 'Due in ${difference}d';
  }
}
