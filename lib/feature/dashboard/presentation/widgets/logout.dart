import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:subzero/common/constant/ui_helpers.dart';

import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/theme/app_theme.dart';

import '../../../../common/constant/app_image.dart';

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
          lHeightSpan,
          Image.asset(AppImage.logout, width: 44.w, height: 44.h),
          mHeightSpan,
          KText(
            text: 'Log out?',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.4,
          ),
          xsHeightSpan,
          KText(
            text:
                'You\'ll need to sign in again to\naccess your subscriptions.',
            fontSize: 13.sp,
            color: Colors.grey.shade500,
            textAlign: TextAlign.center,
          ),
          lHeightSpan,
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
          mHeightSpan,
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
  }

  try {
    await Purchases.logOut();
  } catch (error) {
    debugPrint('⚠️ RevenueCat signOut failed: $error');
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
