import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';

Widget emptyState() {
  return SliverFillRemaining(
    hasScrollBody: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        mHeightSpan,
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_long_outlined,
            size: 32.sp,
            color: Colors.grey.shade400,
          ),
        ),
        mHeightSpan,
        KText(
          text: 'No Subscriptions Yet',
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: Colors.grey.shade700,
        ),
        sHeightSpan,
        KText(
          text: 'Tap + to start tracking\nyour subscriptions.',
          color: Colors.grey.shade400,
          textAlign: TextAlign.center,
          fontSize: 13.sp,
        ),
      ],
    ),
  );
}
