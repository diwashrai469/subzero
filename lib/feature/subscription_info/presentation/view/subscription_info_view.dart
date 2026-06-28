import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/subscription_info/presentation/cubit/subscription_info_cubit.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/cost_breakdown_card.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/hero_header.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/info_card.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/shared_widgets.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/utils.dart';

@RoutePage()
class SubscriptionInfoView extends StatelessWidget {
  final SubscriptionModel sub;

  const SubscriptionInfoView({super.key, required this.sub});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionInfoCubit(sub),
      child: _SubscriptionInfoBody(sub: sub),
    );
  }
}

class _SubscriptionInfoBody extends StatelessWidget {
  final SubscriptionModel sub;

  const _SubscriptionInfoBody({required this.sub});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 34.w),
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 22.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 44.w,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: const Color(0xFFEF4444),
                    size: 23.sp,
                  ),
                ),

                SizedBox(height: 14.h),

                Text(
                  'Delete Subscription?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF111827),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2.w,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Are you sure you want to delete "${sub.name}"? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.5.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 18.h),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.r),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          foregroundColor: const Color(0xFF374151),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);

                          await locator<SubscriptionFirebaseService>()
                              .deleteSubscription(id: sub.id);

                          locator<AppRouters>().replaceAll([
                            const DashboardView(),
                          ]);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.r),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SubscriptionInfoCubit>().state;
    final urgency = SubscriptionInfoCubit.urgencyColor(state.daysUntilBilling);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 265.h,
            pinned: false,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: const Color(0xFFF5F5F7),
            leading: NavButton(
              onTap: () => locator<AppRouters>().popForced(),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFF374151),
                size: 18.sp,
              ),
            ),
            actions: [
              EditButton(
                onTap: () => locator<AppRouters>().push(
                  AddSubscriptionView(existingSub: sub),
                ),
              ),

              NavButton(
                onTap: () => _confirmDelete(context),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: const Color(0xFFEF4444),
                  size: 19.sp,
                ),
              ),

              SizedBox(width: 10.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: HeroHeader(
                sub: sub,
                daysUntilBilling: state.daysUntilBilling,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel(label: 'Cost Breakdown'),
                  SizedBox(height: 10.h),
                  CostBreakdownCard(
                    currency: sub.currency,
                    daily: state.dailyEquivalent,
                    monthly: state.monthlyEquivalent,
                    yearly: state.yearlyEquivalent,
                  ),

                  SizedBox(height: 22.h),

                  const SectionLabel(label: 'Billing Details'),
                  SizedBox(height: 10.h),
                  InfoCard(
                    rows: [
                      InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'First Billed',
                        value: formatDate(sub.firstBillDate),
                      ),
                      InfoRow(
                        icon: Icons.event_outlined,
                        label: 'Next Bill',
                        value: formatDate(state.nextBillDate),
                        valueColor: urgency,
                      ),
                      InfoRow(
                        icon: Icons.repeat_outlined,
                        label: 'Billing Cycle',
                        value: capitalize(sub.billingCycle),
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  const SectionLabel(label: 'Subscription Info'),
                  SizedBox(height: 10.h),
                  InfoCard(
                    rows: [
                      InfoRow(
                        icon: Icons.sell_outlined,
                        label: 'Category',
                        value: capitalize(sub.category),
                      ),
                      InfoRow(
                        icon: Icons.paid_outlined,
                        label: 'Currency',
                        value: sub.currency,
                      ),
                      InfoRow(
                        icon: Icons.check_circle_outline,
                        label: 'Status',
                        trailing: const ActivePill(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
