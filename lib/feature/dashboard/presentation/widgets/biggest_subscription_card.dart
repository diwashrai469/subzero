import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/amount_format_helper.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/theme/app_theme.dart';

class BiggestSubscriptionCard extends StatelessWidget {
  final List<SubscriptionModel> subscriptions;
  final double percentage;

  const BiggestSubscriptionCard({
    super.key,
    required this.subscriptions,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const SizedBox.shrink();
    }

    final groups = _groupSubscriptions(subscriptions);
    final hasMultipleGroups = groups.length > 1;
    final hasMultipleSubscriptions = subscriptions.length > 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.dg),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 6, 47, 94),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _Label('BIGGEST COST'),
              _PercentagePill(
                percentage: percentage,
                isCombined: subscriptions.length > 1,
              ),
            ],
          ),

          sHeightSpan,

          // A single group means every subscription shares the same
          // currency AND amount, so we keep the original "hero" layout.
          // Multiple groups mean we have genuinely distinct amounts to
          // show, so each gets exactly one row — no repeats.
          if (hasMultipleGroups)
            _GroupedSubscriptionList(groups: groups)
          else
            _SingleGroupContent(group: groups.first),

          sHeightSpan,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KText(
                text: hasMultipleSubscriptions
                    ? 'Your highest subscriptions'
                    : 'Your highest subscription',
                color: const Color(0x61FFFFFF),
              ),
              KText(
                text: hasMultipleSubscriptions ? 'per month each' : 'per month',
                fontSize: 11.sp,
                color: disabledSoftColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Groups subscriptions that share the same currency AND amount so they
  /// render as a single row (e.g. "Netflix, Hulu  $9.99") instead of
  /// printing the identical amount once per subscription.
  List<_SubscriptionGroup> _groupSubscriptions(
    List<SubscriptionModel> subscriptions,
  ) {
    final Map<String, _SubscriptionGroup> groupsByKey = {};
    final List<_SubscriptionGroup> orderedGroups = [];

    for (final subscription in subscriptions) {
      final currency = subscription.currency.trim().isEmpty
          ? r'$'
          : subscription.currency.trim();
      // Round to cents to avoid floating point comparison issues
      // (e.g. 9.990000000000001 != 9.99).
      final normalizedAmount = (subscription.amount * 100).round();
      final key = '${currency.toUpperCase()}|$normalizedAmount';

      final existing = groupsByKey[key];
      if (existing != null) {
        existing.subscriptions.add(subscription);
      } else {
        final group = _SubscriptionGroup(
          currency: currency,
          amount: subscription.amount,
          subscriptions: [subscription],
        );
        groupsByKey[key] = group;
        orderedGroups.add(group);
      }
    }

    return orderedGroups;
  }
}

/// A collection of subscriptions that share the same currency and amount.
class _SubscriptionGroup {
  final String currency;
  final double amount;
  final List<SubscriptionModel> subscriptions;

  _SubscriptionGroup({
    required this.currency,
    required this.amount,
    required this.subscriptions,
  });

  String get displayName {
    final count = subscriptions.length;
    final shownNames = subscriptions
        .take(2)
        .map((subscription) => subscription.name)
        .join(', ');

    return count > 2 ? '$shownNames +${count - 2} more' : shownNames;
  }
}

/// Used when every subscription collapses into a single currency+amount
/// group — the original large "hero" layout.
class _SingleGroupContent extends StatelessWidget {
  final _SubscriptionGroup group;

  const _SingleGroupContent({required this.group});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KText(
          text: group.displayName,
          color: Colors.white,
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),

        mWidthSpan,

        _AmountText(currency: group.currency, amount: group.amount),
      ],
    );
  }
}

/// Used when subscriptions fall into two or more distinct currency+amount
/// groups. Each group gets exactly one row, so identical amounts never
/// appear more than once.
class _GroupedSubscriptionList extends StatelessWidget {
  final List<_SubscriptionGroup> groups;

  const _GroupedSubscriptionList({required this.groups});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(groups.length, (index) {
        final group = groups[index];

        return Padding(
          padding: EdgeInsets.only(bottom: index < groups.length - 1 ? 6.h : 0),
          child: Row(
            children: [
              Expanded(
                child: KText(
                  text: group.displayName,
                  color: Colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(width: 12.w),

              _AmountText(
                currency: group.currency,
                amount: group.amount,
                compact: true,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _AmountText extends StatelessWidget {
  final String currency;
  final double amount;
  final bool compact;

  const _AmountText({
    required this.currency,
    required this.amount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return KText(
      text: AmountFormatHelper.formatCurrency(amount, currency),
      fontSize: compact ? 18.sp : 26.sp,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: -0.5,
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return KText(
      text: text,
      fontSize: 11.sp,
      color: disabledColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    );
  }
}

class _PercentagePill extends StatelessWidget {
  final double percentage;
  final bool isCombined;

  const _PercentagePill({required this.percentage, this.isCombined = false});

  @override
  Widget build(BuildContext context) {
    final safePercentage = percentage.clamp(0, 100);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: KText(
        text:
            '${safePercentage.toStringAsFixed(0)}% ${isCombined ? 'combined' : 'of spend'}',
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: disabledColor,
      ),
    );
  }
}
