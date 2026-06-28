import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/notification/presentation/constant/notification_constant.dart';

class NotificationEmptyStateView extends StatelessWidget {
  const NotificationEmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _EmptyIcon(),

          SizedBox(height: 26.h),

          KText(
            text: 'You’re all caught up',
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: NotificationColors.ink,
            letterSpacing: -0.6,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: KText(
              text:
                  'Renewal reminders, payment alerts and important updates will appear here.',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: NotificationColors.subtext,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 104.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: NotificationColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 74.w,
          height: 74.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: NotificationColors.divider.withValues(alpha: 0.35),
            border: Border.all(
              color: NotificationColors.divider.withValues(alpha: 0.8),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 34.sp,
                color: NotificationColors.subtext,
              ),

              Positioned(
                right: 14.w,
                top: 16.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NotificationColors.subtext.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
