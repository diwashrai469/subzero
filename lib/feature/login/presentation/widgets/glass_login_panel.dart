import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';
import 'package:subzero/feature/login/presentation/widgets/auth_glyph.dart';

import 'auth_button.dart';

class GlassLoginPanel extends StatelessWidget {
  const GlassLoginPanel({
    super.key,
    required this.isGoogleLoading,
    required this.onGooglePressed,
  });

  final bool isGoogleLoading;
  final VoidCallback onGooglePressed;

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
                label: AuthCopy.continueWithGoogle,
                icon: GoogleGlyph(size: 18.w),
                backgroundColor: AuthPalette.glassFill,
                foregroundColor: AuthPalette.textPrimary,
                borderColor: AuthPalette.glassStroke,
                isLoading: isGoogleLoading,
                onTap: onGooglePressed,
              ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
