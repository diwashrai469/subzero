import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/theme/app_theme.dart';

Future<void> logout(BuildContext context) async {
  final shouldLogout = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.logout_rounded, size: 24.sp, color: Colors.black),
          ),
          SizedBox(height: 14.h),
          KText(
            text: 'Log out?',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.4,
          ),
          SizedBox(height: 6.h),
          KText(
            text:
                'You\'ll need to sign in again to\naccess your subscriptions.',
            fontSize: 13.sp,
            color: Colors.grey.shade500,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28.h),
          GestureDetector(
            onTap: () => Navigator.of(sheetContext).pop(true),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                color: errorColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: KText(
                text: 'Log out',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => Navigator.of(sheetContext).pop(false),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: KText(
                text: 'Cancel',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  if (shouldLogout != true) return;

  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  final providerIds =
      user?.providerData.map((provider) => provider.providerId).toSet() ??
      <String>{};

  final signedInWithGoogle = providerIds.contains('google.com');

  if (signedInWithGoogle) {
    try {
      await GoogleSignIn().signOut();
    } catch (error) {
      debugPrint('⚠️ Google signOut failed: $error');
    }

    try {
      await GoogleSignIn().disconnect();
    } catch (error) {
      debugPrint('⚠️ Google disconnect failed: $error');
    }
  }

  try {
    await auth.signOut();
  } catch (error) {
    debugPrint('❌ Firebase signOut failed: $error');
  }

  if (!context.mounted) return;

  locator<AppRouters>().pushAndPopUntil(
    const AuthGateView(),
    predicate: (_) => false,
  );
}
