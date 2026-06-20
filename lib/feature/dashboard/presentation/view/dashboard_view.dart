import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/biggest_subscription_card.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/sub_row.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/summary_card.dart';

@RoutePage()
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Widget _list(List<SubscriptionModel> items) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
      sliver: SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          return SubRow(sub: items[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<DashboardCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F7),
          floatingActionButton: Container(
            width: 55.w,
            height: 55.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () =>
                  locator<AppRouters>().push(AddSubscriptionView()),
              backgroundColor: Colors.black,
              elevation: 0,
              shape: const CircleBorder(),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 36.sp),
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.dg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: "SubZero",
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            KText(
                              text: "Your recurring spend, simplified.",
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10.h),

                            SummaryCard(
                              label: "Monthly Spend",
                              currencySymbol: state.allSubs.first.currency,
                              value: state.monthlySpend.toStringAsFixed(2),
                              yearlyValue: state.yearlySpend.toStringAsFixed(2),
                              badge: state.allSubs.length.toString(),
                            ),

                            if (state.biggestSubs.isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              BiggestSubscriptionCard(
                                subscriptions: state.biggestSubs,
                                percentage: state.biggestSubPercentage,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(14.dg),
                        child: KText(
                          text: "All SUBSCRIPTIONS",
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (state.allSubs.isEmpty)
                      SliverFillRemaining(
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
                              text:
                                  'Tap + to start tracking\nyour subscriptions.',
                              color: Colors.grey.shade400,
                              textAlign: TextAlign.center,
                              fontSize: 13.sp,
                            ),
                          ],
                        ),
                      )
                    else
                      _list(state.allSubs),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
