import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/feature/dashboard/helper/dashboard_helper.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/logout.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/sparkle_pro_badge.dart';
import 'package:subzero/feature/upgrade_to_pro/presentation/upgrade_to_pro_view.dart';
import 'package:subzero/theme/app_theme.dart';

const _proGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF082F5B), Color(0xFF0E4B86), Color(0xFF315FC5)],
);

void showProfileSheet(BuildContext context, bool isPro) {
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
                mHeightSpan,
                _buildDeleteAccountButton(context),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// ---------------------------------------------------------------------------
// DELETE ACCOUNT
// ---------------------------------------------------------------------------

Widget _buildDeleteAccountButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.pop(context);

      locator<AppRouters>().push(const DeleteAccountView());
    },
    style: TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: Colors.grey.shade500,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.delete_outline_rounded, size: 18.sp, color: errorColor),

        SizedBox(width: 6.w),

        KText(
          text: 'Delete account',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: errorColor,
        ),
        SizedBox(width: 6.w),
        Icon(Icons.arrow_forward, size: 15.sp, color: errorColor),
      ],
    ),
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
            text: 'Logout',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFD93025),
          ),
        ],
      ),
    ),
  );
}

Widget upgradeFeature({
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
