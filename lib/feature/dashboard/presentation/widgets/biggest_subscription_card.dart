import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    if (subscriptions.isEmpty) return const SizedBox.shrink();

    final first = subscriptions.first;
    final currency = first.currency.isEmpty ? r'$' : first.currency;
    final amount = first.amount;
    final count = subscriptions.length;
    final hasMultiple = count > 1;

    final shownNames = subscriptions.take(2).map((s) => s.name).join(', ');
    final nameText = count > 2 ? '$shownNames +${count - 2} more' : shownNames;

    return Container(
      width: .infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 6, 47, 94),

        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      padding: EdgeInsets.all(18.dg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const _Label('BIGGEST COST'),
              _PercentagePill(percentage: percentage),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),
                    const Text(
                      'Your highest subscription',
                      style: TextStyle(fontSize: 12, color: Color(0x61FFFFFF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _AmountBlock(
                currency: currency,
                amount: amount,
                perMonthLabel: hasMultiple ? 'per month each' : 'per month',
              ),
            ],
          ),
        ],
      ),
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
  const _PercentagePill({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5).dg,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: KText(
        text: '${percentage.toStringAsFixed(0)}% of spend',
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: disabledColor,
      ),
    );
  }
}

class _AmountBlock extends StatelessWidget {
  final String currency;
  final double amount;
  final String perMonthLabel;

  const _AmountBlock({
    required this.currency,
    required this.amount,
    required this.perMonthLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: currency,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: disabledSoftColor,
                  height: 1.55,
                ),
              ),
              TextSpan(
                text: amount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        xxsHeightSpan,
        KText(text: perMonthLabel, fontSize: 11.sp, color: disabledSoftColor),
      ],
    );
  }
}
