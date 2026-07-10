import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';

class CostBreakdownCard extends StatelessWidget {
  final String currency;
  final double daily;
  final double monthly;
  final double yearly;

  const CostBreakdownCard({
    super.key,
    required this.currency,
    required this.daily,
    required this.monthly,
    required this.yearly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CostCell(
              label: 'Daily',
              value: '$currency${daily.toStringAsFixed(2)}',
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: _CostCell(
                label: 'Monthly',
                value: '$currency${monthly.toStringAsFixed(2)}',
                highlight: true,
              ),
            ),
          ),
          Expanded(
            child: _CostCell(
              label: 'Yearly',
              value: '$currency${yearly.toStringAsFixed(0)}',
            ),
          ),
        ],
      ),
    );
  }
}

class _CostCell extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _CostCell({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Column(
        children: [
          KText(text: label, fontSize: 10.sp, color: Colors.grey),
          sHeightSpan,
          KText(
            text: value,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: highlight ? const Color(0xFF6366F1) : Colors.black,
          ),
        ],
      ),
    );
  }
}
