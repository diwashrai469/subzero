import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';

/// A card that renders a vertical list of [InfoRow]s with dividers between them.
class InfoCard extends StatelessWidget {
  final List<InfoRow> rows;

  const InfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          return Column(
            children: [
              rows[i],
              if (i < rows.length - 1)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 58.w,
                  color: const Color(0xFFF3F4F6),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// A single row inside [InfoCard].
class InfoRow extends StatelessWidget {
  final String image;
  final String label;
  final String? value;
  final Color? valueColor;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.image,
    required this.label,
    this.value,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FF),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE6E9F5), width: 0.8),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          mWidthSpan,
          KText(
            text: label,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: const Color(0xFF6B7280),
          ),
          const Spacer(),
          trailing ??
              KText(
                text: value ?? '',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black,
              ),
        ],
      ),
    );
  }
}
