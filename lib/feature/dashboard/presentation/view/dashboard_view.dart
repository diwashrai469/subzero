import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:subzero/feature/dashboard/presentation/widgets/logout.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/sparkle_pro_badge.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/sub_row.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/summary_card.dart';
import 'package:subzero/feature/upgrade_to_pro/presentation/upgrade_to_pro_view.dart';
import 'package:subzero/theme/app_theme.dart';

@RoutePage()
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const _proGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF082F5B), Color(0xFF0E4B86), Color(0xFF315FC5)],
  );

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
                                  _showProfileSheet(
                                    context,
                                    context.read<ProCubit>().state.isPro,
                                  );
                                },
                                onNotificationTap: () {
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
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Upgrade to Pro'),
          content: const Text(
            'Free users can add up to 10 recurring payments.\n\n'
            'Upgrade to Pro for unlimited recurring payments.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Later'),
            ),
            ElevatedButton(
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
              child: const Text('Upgrade'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openNotifications(BuildContext context) async {
    locator<AppRouters>().push(const NotificationView());

    await context.read<DashboardCubit>().markAllNotificationsAsSeen();
  }

  void _showProfileSheet(BuildContext context, bool isPro) {
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 24.h),
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
                  lHeightSpan,
                  Stack(
                    children: [
                      ProfileAvatar(user: user, size: 84.r, showBorder: false),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: isPro ? const SparkleProBadge() : freeText(),
                      ),
                    ],
                  ),

                  mHeightSpan,
                  KText(
                    text: displayName(user),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.4,
                    textAlign: TextAlign.center,
                  ),

                  xsHeightSpan,
                  KText(
                    text: user?.email ?? 'No email available',
                    fontSize: 13.sp,
                    color: Colors.grey.shade500,
                    textAlign: TextAlign.center,
                  ),
                  lHeightSpan,
                  _buildAccountCard(user),
                  mHeightSpan,
                  BlocBuilder<ProCubit, dynamic>(
                    builder: (context, state) {
                      return _buildMembershipCard(context, isPro: state.isPro);
                    },
                  ),
                  mHeightSpan,
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountCard(User? user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.verified_user_outlined, size: 21.sp),
          ),
          mWidthSpan,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: DashboardHelper().signedInText(user),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                4.verticalSpace,
                KText(
                  text: 'Your subscriptions are synced securely.',
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, {required bool isPro}) {
    final title = isPro ? 'SubZero Pro' : 'Upgrade to Pro';

    final description = isPro
        ? 'Unlimited subscriptions and smart reminders are unlocked.'
        : 'Unlock unlimited subscriptions and smart reminders.';

    return InkWell(
      onTap: isPro
          ? null
          : () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const UpgradeToProView(),
                ),
              );
            },
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: _proGradient,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF315FC5).withValues(alpha: 0.20),
              blurRadius: 22.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                size: 24.sp,
                color: const Color(0xFFFFD166),
              ),
            ),
            13.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: KText(
                          text: title,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: isPro
                              ? const Color(0xFFB9F6CA)
                              : const Color(0xFFFFD166),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: KText(
                          text: isPro ? 'ACTIVE' : 'LIFETIME',
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: isPro
                              ? const Color(0xFF075E34)
                              : const Color(0xFF5C4300),
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  KText(
                    text: description,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.78),
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPro ? Icons.check_rounded : Icons.arrow_forward_rounded,
                size: 19.sp,
                color: isPro ? const Color(0xFFB9F6CA) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        await logout(context);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
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
            sWidthSpan,
            KText(
              text: 'Log out',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD93025),
            ),
          ],
        ),
      ),
    );
  }
}
