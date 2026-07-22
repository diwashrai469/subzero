import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/amount_format_helper.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/subscription_category.dart';
import 'package:subzero/theme/app_theme.dart';

class HeroHeader extends StatelessWidget {
  final SubscriptionModel sub;
  final int daysUntilBilling;

  const HeroHeader({
    super.key,
    required this.sub,
    required this.daysUntilBilling,
  });

  @override
  Widget build(BuildContext context) {
    final String billingText = daysUntilBilling == 0
        ? 'Renews Today'
        : daysUntilBilling == 1
        ? 'Renews Tomorrow'
        : 'Renews in $daysUntilBilling days';

    return Container(
      color: const Color(0xFFF5F5F7),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Hero(
              tag: 'subscription-hero-${sub.id}',
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: toHeroContext.widget,
                      ),
                    );
                  },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 77.r,
                  height: 77.r,
                  decoration: BoxDecoration(
                    color: scaffoldBgColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Center(
                    child: SubscriptionCategoryIcon(
                      category: sub.category,
                      size: 47.w,
                    ),
                  ),
                ),
              ),
            ),

            sHeightSpan,

            KText(
              text: sub.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7280),
            ),

            sHeightSpan,

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AmountFormatHelper.formatCurrency(
                      sub.amount,
                      sub.currency,
                    ),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  TextSpan(
                    text: ' / ${_cycleLabel(sub.billingCycle)}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            mHeightSpan,

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 15.sp,
                    color: const Color(0xFFB45309),
                  ),
                  sWidthSpan,
                  KText(
                    text: billingText,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB45309),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cycleLabel(String cycle) {
    switch (cycle.toLowerCase()) {
      case 'monthly':
        return 'month';
      case 'yearly':
      case 'annual':
      case 'annually':
        return 'year';
      case 'weekly':
        return 'week';
      default:
        return cycle;
    }
  }
}
