import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';
import 'package:subzero/feature/login/presentation/widgets/auth_glyph.dart';

import 'auth_button.dart';

class GlassLoginPanel extends StatelessWidget {
  const GlassLoginPanel({
    super.key,
    required this.isAppleLoading,
    required this.isGoogleLoading,
    required this.onApplePressed,
    required this.onGooglePressed,
    required this.onGuestPressed,
  });

  final bool isAppleLoading;
  final bool isGoogleLoading;
  final VoidCallback onApplePressed;
  final VoidCallback onGooglePressed;
  final VoidCallback onGuestPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
          decoration: BoxDecoration(
            color: AuthPalette.glassFill,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: AuthPalette.glassStroke, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AuthCopy.continueWith,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: AuthPalette.textTertiary,
                ),
              ),

              SizedBox(height: 16.h),

              AuthButton(
                label: AuthCopy.continueWithApple,
                icon: AppleGlyph(size: 18.w),
                backgroundColor: Colors.white,
                foregroundColor: AuthPalette.bgTop,
                isLoading: isAppleLoading,
                onTap: onApplePressed,
              ),

              SizedBox(height: 12.h),

              AuthButton(
                label: AuthCopy.continueWithGoogle,
                icon: GoogleGlyph(size: 18.w),
                backgroundColor: AuthPalette.glassFill,
                foregroundColor: AuthPalette.textPrimary,
                borderColor: AuthPalette.glassStroke,
                isLoading: isGoogleLoading,
                onTap: onGooglePressed,
              ),

              SizedBox(height: 18.h),

              const _DividerWithText(),

              SizedBox(height: 16.h),

              _GuestButton(onTap: onGuestPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _HairlineDivider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            AuthCopy.or,
            style: TextStyle(
              fontSize: 11.5.sp,
              color: AuthPalette.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: _HairlineDivider()),
      ],
    );
  }
}

class _HairlineDivider extends StatelessWidget {
  const _HairlineDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AuthPalette.glassStroke);
  }
}

class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Text(
          AuthCopy.continueAsGuest,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AuthPalette.ice,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
