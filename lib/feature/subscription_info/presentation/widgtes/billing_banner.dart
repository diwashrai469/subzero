import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/utils.dart';

class BillingBanner extends StatelessWidget {
  final int days;
  final Color urgencyColor;
  final DateTime nextBillDate;
  final String message;

  const BillingBanner({
    super.key,
    required this.days,
    required this.urgencyColor,
    required this.nextBillDate,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: urgencyColor.withValues(alpha: 20),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: urgencyColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          _UrgencyIcon(urgencyColor: urgencyColor),
          sWidthSpan,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text: message,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: urgencyColor,
              ),
              xxsHeightSpan,
              KText(
                text: formatDateSlash(nextBillDate),
                fontSize: 11.sp,
                color: urgencyColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UrgencyIcon extends StatelessWidget {
  final Color urgencyColor;

  const _UrgencyIcon({required this.urgencyColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: urgencyColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        Icons.notifications_active_outlined,
        color: urgencyColor,
        size: 20.sp,
      ),
    );
  }
}
