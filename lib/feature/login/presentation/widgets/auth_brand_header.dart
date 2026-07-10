import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';

import 'app_icon_mark.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key, required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeOutCubic,
      scale: compact ? 0.92 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIconMark(),
          SizedBox(height: compact ? 22.h : 26.h),
          KText(
            text: AuthCopy.appName,
            fontSize: compact ? 30.sp : 28.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: AuthPalette.textPrimary,
          ),
          SizedBox(height: compact ? 10.h : 8.h),
          Text(
            AuthCopy.tagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 14.5.sp : 13.sp,
              fontWeight: FontWeight.w400,
              color: AuthPalette.textSecondary,
              height: compact ? 1.45 : 1.35,
              letterSpacing: compact ? 0.1 : 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
