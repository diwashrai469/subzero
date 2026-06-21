import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/fcm_service.dart';
import 'package:subzero/core/services/toast/toast_service.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';
import 'package:subzero/feature/login/presentation/widgets/auth_background.dart';
import 'package:subzero/feature/login/presentation/widgets/auth_brand_header.dart';
import 'package:subzero/feature/login/presentation/widgets/glass_login_panel.dart';
import 'package:subzero/feature/login/presentation/widgets/login_legal_text.dart';
import 'package:subzero/feature/login/presentation/widgets/plusing_dot.dart';

enum AuthGateStatus { checking, unauthenticated, authenticated }

@RoutePage()
class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView>
    with SingleTickerProviderStateMixin {
  final AppRouters _appRoutes = locator<AppRouters>();

  AuthGateStatus _status = AuthGateStatus.checking;

  bool _isAppleLoading = false;
  bool _isGoogleLoading = false;

  late final AnimationController _introController;
  late final Animation<double> _introFade;
  late final Animation<double> _introScale;

  bool get _isChecking => _status == AuthGateStatus.checking;
  bool get _showLoginOptions => _status == AuthGateStatus.unauthenticated;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _introFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _introScale = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _startAuthFlow();
  }

  Future<void> _startAuthFlow() async {
    await _introController.forward();

    await Future<void>.delayed(const Duration(milliseconds: 550));

    if (!mounted) return;

    final result = await _checkInitialRoute();

    if (!mounted) return;

    switch (result) {
      case _InitialRoute.dashboard:
        _goToDashboard();
        return;

      case _InitialRoute.onboarding:
        // _goToOnboarding();
        return;

      case _InitialRoute.login:
        setState(() {
          _status = AuthGateStatus.unauthenticated;
        });
        return;
    }
  }

  Future<_InitialRoute> _checkInitialRoute() async {
    final user = await FirebaseAuth.instance.authStateChanges().first;

    if (user == null) {
      return _InitialRoute.login;
    }

    await FCMService.saveTokenForCurrentUser();

    return _InitialRoute.dashboard;
  }

  void _goToDashboard() {
    _appRoutes.pushAndPopUntil(const DashboardView(), predicate: (_) => false);
  }

  // void _goToOnboarding() {
  //   _appRoutes.pushAndPopUntil(const OnboardingView(), predicate: (_) => false);
  // }

  Future<void> _handleAppleSignIn() async {
    if (_isAppleLoading || _isGoogleLoading) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isAppleLoading = true;
    });

    try {
      // TODO: Add real Apple sign-in here.
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      // After successful sign-in:
      // _goToDashboard();
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isAppleLoading || _isGoogleLoading) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // TODO: Add real Google sign-in here.
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      // After successful sign-in:
      // _goToDashboard();
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _handleGuestMode() async {
    if (_isAppleLoading || _isGoogleLoading) return;

    HapticFeedback.selectionClick();

    try {
      final auth = FirebaseAuth.instance;

      User? user = auth.currentUser;

      if (user == null) {
        final credential = await auth.signInAnonymously();
        user = credential.user;
      }

      if (user == null) {
        locator<ToastService>().e('Guest mode failed. Please try again.');
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'isAnonymous': user.isAnonymous,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FCMService.saveTokenForCurrentUser();

      if (!mounted) return;

      _goToDashboard();
    } on FirebaseAuthException catch (e) {
      locator<ToastService>().e('Guest mode failed. Please try again.');
      debugPrint('Anonymous sign-in failed: ${e.code} - ${e.message}');
    } catch (e) {
      locator<ToastService>().e('Guest mode failed. Please try again.');
      debugPrint('Guest mode failed: $e');
    }
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AuthPalette.bgBottom,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AuthBackground(
            glowAlignment: _isChecking
                ? const Alignment(0, -0.08)
                : const Alignment(0, -0.58),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 720),
                    curve: Curves.easeOutCubic,
                    alignment: _isChecking
                        ? const Alignment(0, -0.08)
                        : const Alignment(0, -0.48),
                    child: FadeTransition(
                      opacity: _introFade,
                      child: ScaleTransition(
                        scale: _introScale,
                        child: AuthBrandHeader(compact: _showLoginOptions),
                      ),
                    ),
                  ),

                  Align(
                    alignment: const Alignment(0, 0.88),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _isChecking
                          ? const PulsingDots(key: ValueKey('loading-dots'))
                          : const SizedBox.shrink(
                              key: ValueKey('empty-loading-dots'),
                            ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 520),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0, 0.12),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(position: slide, child: child),
                        );
                      },
                      child: _showLoginOptions
                          ? Column(
                              key: const ValueKey('login-options'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GlassLoginPanel(
                                  isAppleLoading: _isAppleLoading,
                                  isGoogleLoading: _isGoogleLoading,
                                  onApplePressed: _handleAppleSignIn,
                                  onGooglePressed: _handleGoogleSignIn,
                                  onGuestPressed: _handleGuestMode,
                                ),
                                SizedBox(height: 18.h),
                                const LoginLegalText(),
                                SizedBox(height: (bottomInset > 0 ? 12 : 24).h),
                              ],
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('empty-login-options'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _InitialRoute { login, dashboard, onboarding }
