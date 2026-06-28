import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/biggest_subscription_card.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/empty_state.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/logout.dart';
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

  void _showProfileSheet(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 34.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),

              SizedBox(height: 24.h),

              LargeProfileAvatar(user: user),

              SizedBox(height: 14.h),

              KText(
                text: displayName(user),
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.4,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              KText(
                text: user?.email ?? 'No email available',
                fontSize: 13.sp,
                color: Colors.grey.shade500,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        size: 21.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: signedInText(user),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          SizedBox(height: 2.h),
                          KText(
                            text: 'Your subscriptions are synced securely.',
                            fontSize: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await logout(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFEF),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 20.sp,
                        color: const Color(0xFFD93025),
                      ),
                      SizedBox(width: 8.w),
                      KText(
                        text: 'Log out',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD93025),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String signedInText(User? user) {
    final providers =
        user?.providerData.map((e) => e.providerId).toList() ?? [];

    if (providers.contains('google.com')) {
      return 'Signed in with Google';
    }

    if (providers.contains('apple.com')) {
      return 'Signed in with Apple';
    }

    return 'Signed in securely';
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
              onPressed: () {
                locator<AppRouters>().push(AddSubscriptionView());
              },
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

                final currencySymbol = state.allSubs.isEmpty
                    ? ''
                    : state.allSubs.first.currency;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.dg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DashboardHeader(
                              notificationCount: state.notificationCount,
                              onProfileTap: () => _showProfileSheet(context),
                              onNotificationTap: () async {
                                await context
                                    .read<DashboardCubit>()
                                    .markAllNotificationsAsSeen();

                                if (context.mounted) {
                                  locator<AppRouters>().push(
                                    const NotificationView(),
                                  );
                                }
                              },
                            ),

                            SizedBox(height: 30.h),

                            SummaryCard(
                              label: 'Monthly Spend',
                              currencySymbol: currencySymbol,
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
                          text: 'All SUBSCRIPTIONS',
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (state.allSubs.isEmpty)
                      emptyState()
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
