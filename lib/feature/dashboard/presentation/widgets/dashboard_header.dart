import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/sparkle_pro_badge.dart';
import 'package:subzero/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.onProfileTap,
    required this.onNotificationTap,
    this.notificationCount = 0,
    this.isPro = false,
  });

  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImage.appText,
                    width: 120.w.clamp(90, 140),
                    fit: BoxFit.contain,
                  ),
                  4.horizontalSpace,
                  !isPro
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFE59A),
                                Color(0xFFFFC94A),
                                Color(0xFFF5A623),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5.r,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFF5A623,
                                ).withValues(alpha: 0.28),
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: KText(
                            text: 'Free',
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        )
                      : SparkleProBadge(),
                ],
              ),
              8.verticalSpace,
              KText(
                text: 'Your recurring spend, simplified.',
                fontSize: 14.sp,
                color: Colors.grey,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isPro) _buildNotificationButton(),
        sWidthSpan,
        GestureDetector(
          onTap: onProfileTap,
          child: ProfileAvatar(user: user, size: 43.r),
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    final hasBadge = notificationCount > 0;
    final badgeText = notificationCount > 99
        ? '99+'
        : notificationCount.toString();

    return GestureDetector(
      onTap: onNotificationTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 24.sp,
              color: Colors.black,
            ),
          ),
          if (hasBadge)
            Positioned(
              top: -2.r,
              right: -2.r,
              child: Container(
                constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: notificationCount > 9
                      ? BoxShape.rectangle
                      : BoxShape.circle,
                  borderRadius: notificationCount > 9
                      ? BorderRadius.circular(20.r)
                      : null,
                  border: Border.all(color: Colors.white, width: 2.r),
                ),
                alignment: Alignment.center,
                child: KText(
                  text: badgeText,
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.user,
    required this.size,
    this.showBorder = true,
  });

  final User? user;
  final double size;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL?.trim();
    final initial = getUserInitial(user);
    final fontSize = size * 0.4;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: Colors.white, width: 2.r) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.16),
          ),
        ],
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _buildInitial(initial, fontSize);
                },
              )
            : _buildInitial(initial, fontSize),
      ),
    );
  }

  Widget _buildInitial(String initial, double fontSize) {
    return Center(
      child: KText(
        text: initial,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );
  }
}

String getUserInitial(User? user) {
  final name = user?.displayName?.trim();
  final email = user?.email?.trim();
  final value = name?.isNotEmpty == true ? name : email;

  return value?.isNotEmpty == true ? value![0].toUpperCase() : 'U';
}

String displayName(User? user) {
  final name = user?.displayName?.trim();

  if (name?.isNotEmpty == true) {
    return name!;
  }

  final email = user?.email?.trim();

  if (email?.isNotEmpty == true) {
    return email!.split('@').first;
  }

  return 'SubZero User';
}

Widget freeText() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFE59A), Color(0xFFFFC94A), Color(0xFFF5A623)],
      ),
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: Colors.white, width: 1.5.r),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFF5A623).withValues(alpha: 0.28),
          blurRadius: 10.r,
          offset: Offset(0, 4.h),
        ),
      ],
    ),
    child: KText(
      text: 'Free',
      fontSize: 8.sp,
      fontWeight: FontWeight.w900,
      color: primaryColor,
      letterSpacing: 0.5,
    ),
  );
}
