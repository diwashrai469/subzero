import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:subzero/common/constant/amount_format_helper.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/theme/app_theme.dart';

class SummaryCard extends StatefulWidget {
  final String label;
  final String badge;

  final Map<String, double> monthlySpendByCurrency;

  final Map<String, double> yearlySpendByCurrency;

  const SummaryCard({
    super.key,
    required this.label,
    required this.badge,
    required this.monthlySpendByCurrency,
    required this.yearlySpendByCurrency,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _currentMonthYear {
    return DateFormat('d MMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final monthly = _CurrencyTotals.from(widget.monthlySpendByCurrency);
    final yearly = _CurrencyTotals.from(widget.yearlySpendByCurrency);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.dg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                Color.lerp(primaryColor, Colors.black, 0.18) ?? primaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: widget.label.toUpperCase(),
                    fontSize: 11.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                  KText(
                    text: _currentMonthYear,
                    fontSize: 11.sp,
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              sHeightSpan,

              _PrimaryTotal(totals: monthly),

              mHeightSpan,

              Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),

              sHeightSpan,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.credit_card_rounded,
                      label: 'Active',
                      value: widget.badge,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32.h,
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'This year',
                      value: yearly.primaryCompactLabel,
                      subValue: yearly.secondaryCompactLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryTotal extends StatelessWidget {
  final _CurrencyTotals totals;

  const _PrimaryTotal({required this.totals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: KText(
            key: ValueKey(totals.primaryFullLabel),
            text: totals.primaryFullLabel,
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (totals.secondaryCompactLabel != null) ...[
          xsHeightSpan,
          KText(
            text: totals.secondaryCompactLabel!,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white54,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white54, size: 16.sp),
        sWidthSpan,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text: label,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
              SizedBox(height: 2.h),
              KText(
                text: value,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              if (subValue != null)
                KText(
                  text: subValue!,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white38,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrencyTotals {
  final List<MapEntry<String, double>> entries;

  const _CurrencyTotals(this.entries);

  factory _CurrencyTotals.from(Map<String, double> values) {
    final filtered =
        values.entries
            .where(
              (entry) =>
                  entry.key.trim().isNotEmpty &&
                  entry.value.isFinite &&
                  entry.value > 0,
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return _CurrencyTotals(filtered);
  }

  MapEntry<String, double>? get _primary =>
      entries.isEmpty ? null : entries.first;

  List<MapEntry<String, double>> get _secondary =>
      entries.length > 1 ? entries.sublist(1) : const [];

  String get primaryFullLabel {
    final primary = _primary;

    if (primary == null) {
      return AmountFormatHelper.formatCurrency(0, 'AUD');
    }

    return AmountFormatHelper.formatCurrency(primary.value, primary.key);
  }

  String get primaryCompactLabel {
    final primary = _primary;

    if (primary == null) {
      return AmountFormatHelper.formatCurrency(0, 'AUD');
    }

    final symbol = AmountFormatHelper.currencySymbol(primary.key);
    final amount = NumberFormat.compact().format(primary.value);

    return '$symbol$amount';
  }

  String? get secondaryCompactLabel {
    if (_secondary.isEmpty) return null;

    final parts = _secondary
        .map((entry) {
          final symbol = AmountFormatHelper.currencySymbol(entry.key);
          final amount = NumberFormat.compact().format(entry.value);
          return '$symbol$amount';
        })
        .join(', ');

    return ' $parts';
  }
}
