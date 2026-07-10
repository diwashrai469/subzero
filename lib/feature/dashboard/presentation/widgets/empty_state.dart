import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/theme/app_theme.dart';

Widget emptyState() {
  return SliverFillRemaining(
    hasScrollBody: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        lHeightSpan,
        Container(
          width: 72.w,
          height: 72.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_long_outlined,
            size: 60.sp,
            color: Colors.grey.shade400,
          ),
        ),
        mHeightSpan,
        KText(
          text: 'No Subscriptions Yet',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: Colors.grey.shade700,
        ),
        sHeightSpan,
        KText(
          text: 'Tap + to start tracking\nyour subscriptions.',
          color: disabledColor,
          textAlign: TextAlign.center,
          fontSize: 13.sp,
        ),
      ],
    ),
  );
}
