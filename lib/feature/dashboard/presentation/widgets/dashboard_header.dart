import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.onProfileTap,
    required this.onNotificationTap,
    this.notificationCount = 0,
  });

  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImage.appText,
                width: 120.w.clamp(90.0, 140.0),
                fit: BoxFit.contain,
              ),

              8.verticalSpace,

              Flexible(
                child: KText(
                  text: 'Your recurring spend, simplified.',
                  fontSize: 14.sp,
                  color: Colors.grey,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
          badgeCount: notificationCount,
        ),

        sWidthSpan,

        GestureDetector(
          onTap: onProfileTap,
          child: _SmallProfileAvatar(user: user),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final hasBadge = badgeCount > 0;
    final buttonSize = 44.r;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
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
            child: Icon(icon, size: 24.sp, color: Colors.black),
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
                  shape: badgeCount > 9 ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: badgeCount > 9
                      ? BorderRadius.circular(20.r)
                      : null,
                  border: Border.all(color: Colors.white, width: 2.r),
                ),
                alignment: Alignment.center,
                child: KText(
                  text: badgeCount > 99 ? '99+' : badgeCount.toString(),
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

class _SmallProfileAvatar extends StatelessWidget {
  const _SmallProfileAvatar({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL;
    final initial = _initial(user);

    final avatarSize = 43.h;

    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 16.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: ClipOval(
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return _InitialAvatar(initial: initial, fontSize: 18.sp);
                  },
                )
              : _InitialAvatar(initial: initial, fontSize: 18.sp),
        ),
      ),
    );
  }
}

class LargeProfileAvatar extends StatelessWidget {
  const LargeProfileAvatar({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL;
    final initial = _initial(user);

    final avatarSize = 84.r;

    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 22.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: ClipOval(
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return _InitialAvatar(initial: initial, fontSize: 32.sp);
                  },
                )
              : _InitialAvatar(initial: initial, fontSize: 32.sp),
        ),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.initial, required this.fontSize});

  final String initial;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
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

String _initial(User? user) {
  final name = user?.displayName?.trim();
  final email = user?.email?.trim();

  if (name != null && name.isNotEmpty) {
    return name[0].toUpperCase();
  }

  if (email != null && email.isNotEmpty) {
    return email[0].toUpperCase();
  }

  return 'U';
}

String displayName(User? user) {
  final name = user?.displayName?.trim();

  if (name != null && name.isNotEmpty) {
    return name;
  }

  final email = user?.email?.trim();

  if (email != null && email.isNotEmpty) {
    return email.split('@').first;
  }

  return 'SubZero User';
}
