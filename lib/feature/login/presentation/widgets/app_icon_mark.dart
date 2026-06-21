import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';

class AppIconMark extends StatelessWidget {
  const AppIconMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112.w,
      height: 112.w,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.40),
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.04),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 14,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 36,
            spreadRadius: -10,
            offset: const Offset(0, 22),
          ),
          BoxShadow(
            color: AuthPalette.ice.withValues(alpha: 0.22),
            blurRadius: 54,
            spreadRadius: -16,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: -6,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.r),
              child: Image.asset(AppImage.appIcon, fit: BoxFit.cover),
            ),
          ),

          Positioned(
            top: 0,
            left: 14.w,
            right: 14.w,
            child: Container(
              height: 1.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.55),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  colors: [
                    Colors.white.withValues(alpha: 0.18),
                    Colors.white.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
