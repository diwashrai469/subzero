import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
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
            text: 'Logout?',
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
                text: 'Logout',
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

  // ------------------------------------------------------------
  // 1. STOP FIRESTORE LISTENERS
  // ------------------------------------------------------------
  //
  // This MUST happen before FirebaseAuth.signOut().
  //
  // Otherwise the Dashboard listeners remain active after the
  // user becomes unauthenticated and Firestore can return:
  //
  // [cloud_firestore/permission-denied]
  //
  try {
    await context.read<DashboardCubit>().stopListening();

    debugPrint('✅ Dashboard listeners stopped');
  } catch (error) {
    debugPrint('⚠️ Failed to stop Dashboard listeners: $error');
  }

  // ------------------------------------------------------------
  // 2. GET CURRENT FCM TOKEN
  // ------------------------------------------------------------
  //
  // We get the token while the user is still authenticated so
  // we can remove it from the correct Firebase user.
  //
  final fcmToken = await FirebaseMessaging.instance.getToken();

  final providerIds =
      user?.providerData.map((provider) => provider.providerId).toSet() ??
      <String>{};

  final signedInWithGoogle = providerIds.contains('google.com');

  // ------------------------------------------------------------
  // 3. REMOVE FCM TOKEN FROM CURRENT USER
  // ------------------------------------------------------------

  if (user != null && fcmToken != null && fcmToken.isNotEmpty) {
    try {
      await locator<SubscriptionFirebaseService>().removeFcmToken(fcmToken);

      debugPrint('✅ FCM token removed from user: ${user.uid}');
    } catch (error) {
      debugPrint('⚠️ Failed to remove FCM token: $error');
    }
  }

  // ------------------------------------------------------------
  // 4. SIGN OUT FROM GOOGLE
  // ------------------------------------------------------------
  //
  // Only if this Firebase account was signed in with Google.
  //
  // Do NOT use disconnect().
  //
  if (signedInWithGoogle) {
    try {
      await GoogleSignIn().signOut();

      debugPrint('✅ Google signed out');
    } catch (error) {
      debugPrint('⚠️ Google signOut failed: $error');
    }
  }

  // ------------------------------------------------------------
  // 5. LOG OUT FROM REVENUECAT
  // ------------------------------------------------------------

  try {
    await Purchases.logOut();

    debugPrint('✅ RevenueCat logged out');
  } catch (error) {
    debugPrint('⚠️ RevenueCat signOut failed: $error');
  }

  // ------------------------------------------------------------
  // 6. SIGN OUT FROM FIREBASE
  // ------------------------------------------------------------

  try {
    await auth.signOut();

    debugPrint('✅ Firebase signed out');
  } catch (error) {
    debugPrint('❌ Firebase signOut failed: $error');
  }

  // ------------------------------------------------------------
  // 7. GO TO AUTH SCREEN
  // ------------------------------------------------------------

  if (!context.mounted) return;

  locator<AppRouters>().pushAndPopUntil(
    const AuthGateView(),
    predicate: (_) => false,
  );
}
