import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';

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

    // Name line: "Netflix, Spotify +1 more"
    final shownNames = subscriptions.take(2).map((s) => s.name).join(', ');
    final nameText = count > 2 ? '$shownNames +${count - 2} more' : shownNames;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: label + percentage pill ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _Label('BIGGEST COST'),
              _PercentagePill(percentage: percentage),
            ],
          ),

          const SizedBox(height: 16),

          // ── Body: name + amount ──
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

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Color(0x61FFFFFF),
        letterSpacing: 0.9,
      ),
    );
  }
}

class _PercentagePill extends StatelessWidget {
  final double percentage;
  const _PercentagePill({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 0.5,
        ),
      ),
      child: Text(
        '${percentage.toStringAsFixed(0)}% of spend',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0x80FFFFFF),
        ),
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
                  color: Color(0x80FFFFFF),
                  // shift up to align with the large number
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
        const SizedBox(height: 3),
        Text(
          perMonthLabel,
          style: TextStyle(fontSize: 11.sp, color: Color(0x4DFFFFFF)),
        ),
      ],
    );
  }
}
