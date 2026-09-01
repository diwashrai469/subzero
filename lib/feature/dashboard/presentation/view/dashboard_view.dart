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
import 'package:subzero/core/pro/constant/pro_constant.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/feature/dashboard/helper/dashboard_helper.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/biggest_subscription_card.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/empty_state.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/profile_bottom_sheet.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/sub_row.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/summary_card.dart';
import 'package:subzero/feature/upgrade_to_pro/presentation/upgrade_to_pro_view.dart';
import 'package:subzero/theme/app_theme.dart';

@RoutePage()
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPro = context.select<ProCubit, bool>((cubit) => cubit.state.isPro);
    return BlocProvider(
      create: (_) => locator<DashboardCubit>(),
      child: Builder(
        builder: (context) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            child: Scaffold(
              floatingActionButton: _buildAddButton(context),
              body: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final monthlySpend = DashboardHelper().spendByCurrency(
                    state.allSubs,
                    yearly: false,
                  );

                  final yearlySpend = DashboardHelper().spendByCurrency(
                    state.allSubs,
                    yearly: true,
                  );

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.dg, 50.dg, 16.dg, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sHeightSpan,
                              DashboardHeader(
                                isPro: context.select<ProCubit, bool>(
                                  (cubit) => cubit.state.isPro,
                                ),
                                notificationCount: state.notificationCount,
                                onProfileTap: () {
                                  showProfileSheet(
                                    context,
                                    context.read<ProCubit>().state.isPro,
                                  );
                                },
                                onNotificationTap: () async {
                                  _openNotifications(context);
                                },
                              ),
                              if (isPro) ...[
                                lHeightSpan,
                                SummaryCard(
                                  label: 'Monthly Spend',
                                  monthlySpendByCurrency: monthlySpend,
                                  yearlySpendByCurrency: yearlySpend,
                                  badge: '${state.allSubs.length}',
                                ),
                                if (state.biggestSubs.isNotEmpty) ...[
                                  sHeightSpan,
                                  BiggestSubscriptionCard(
                                    subscriptions: state.biggestSubs,
                                    percentage: state.biggestSubPercentage,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(14.dg),
                          child: KText(
                            text: 'ALL SUBSCRIPTIONS',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      if (state.allSubs.isEmpty)
                        emptyState()
                      else
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: 14.w,
                            right: 14.w,
                            bottom: 24.h,
                          ),
                          sliver: SliverList.separated(
                            itemCount: state.allSubs.length,
                            separatorBuilder: (_, _) => sHeightSpan,
                            itemBuilder: (_, index) {
                              return SubRow(sub: state.allSubs[index]);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      width: 65.r,
      height: 65.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        onPressed: () => _addSubscription(context),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 32.sp),
      ),
    );
  }

  Future<void> _addSubscription(BuildContext context) async {
    final isPro = context.read<ProCubit>().state.isPro;

    final count = context.read<DashboardCubit>().state.allSubs.length;

    if (!isPro && count >= ProConstants.freeSubscriptionLimit) {
      _showUpgradeDialog(context);
      return;
    }

    locator<AppRouters>().push(AddSubscriptionView(subCount: count));
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pro icon
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  Text(
                    'Unlock SubZero Pro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.6,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'You\'ve reached the free plan limit.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // Features
                  _upgradeFeature(
                    icon: Icons.all_inclusive_rounded,
                    title: 'Unlimited subscriptions',
                    subtitle: 'Track every recurring payment',
                  ),

                  SizedBox(height: 14.h),

                  _upgradeFeature(
                    icon: Icons.notifications_active_outlined,
                    title: 'Flexible reminders',
                    subtitle: 'Choose when you want to be reminded',
                  ),

                  SizedBox(height: 22.h),

                  // Upgrade button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => const UpgradeToProView(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Upgrade to Pro',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: Text(
                      'Maybe later',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _upgradeFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Icon(icon, size: 21.sp, color: Colors.black),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openNotifications(BuildContext context) async {
    locator<AppRouters>().push(const NotificationView());

    await context.read<DashboardCubit>().markAllNotificationsAsSeen();
  }
}
