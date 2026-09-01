import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';

import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/core/pro/service/pro_services.dart';
import 'package:subzero/core/services/firebase/fcm_service.dart';
import 'package:subzero/core/services/toast/toast_service.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';
import 'package:subzero/feature/login/presentation/widgets/auth_background.dart';
import 'package:subzero/feature/login/presentation/widgets/auth_brand_header.dart';
import 'package:subzero/core/services/firebase/auth_firebase_service.dart';
import 'package:subzero/feature/login/presentation/widgets/glass_login_panel.dart';
import 'package:subzero/feature/login/presentation/widgets/login_legal_text.dart';
import 'package:subzero/feature/login/presentation/widgets/plusing_dot.dart';

enum AuthGateStatus { checking, unauthenticated }

@RoutePage()
class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView>
    with SingleTickerProviderStateMixin {
  final ProService _proService = locator<ProService>();
  final ProCubit _proCubit = locator<ProCubit>();
  final AppRouters _appRoutes = locator<AppRouters>();
  final ToastService _toast = locator<ToastService>();
  final AuthFirebaseService _authService = locator<AuthFirebaseService>();

  AuthGateStatus _status = AuthGateStatus.checking;

  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  late final AnimationController _introController;
  late final Animation<double> _introFade;
  late final Animation<double> _introScale;

  bool get _isChecking => _status == AuthGateStatus.checking;
  bool get _showLoginOptions => _status == AuthGateStatus.unauthenticated;
  bool get _isAuthLoading => _isGoogleLoading || _isAppleLoading;

  @override
  void initState() {
    super.initState();
    _setupIntroAnimation();
    _startAuthFlow();
  }

  void _setupIntroAnimation() {
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
  }

  Future<void> _startAuthFlow() async {
    await _introController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 550));

    if (!mounted) return;

    final hasUser = await _hasActiveUser();

    if (!mounted) return;

    if (hasUser) {
      _goToDashboard();
      return;
    }

    setState(() {
      _status = AuthGateStatus.unauthenticated;
    });
  }

  Future<bool> _hasActiveUser() async {
    final user = await FirebaseAuth.instance.authStateChanges().first;

    if (user == null) {
      return false;
    }

    try {
      await user.reload();

      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser == null) {
        return false;
      }

      await FCMService.saveTokenForCurrentUser();

      await _proService.login(refreshedUser.uid);
      await _proCubit.loadProStatus();

      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint('❌ Firebase user is no longer valid: ${error.code}');

      await FirebaseAuth.instance.signOut();

      return false;
    } catch (error) {
      debugPrint('❌ Failed to validate Firebase user: $error');

      return false;
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isAuthLoading) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isAppleLoading = true;
    });

    try {
      final result = await _authService.signInWithApple();

      if (!mounted) return;

      switch (result) {
        case SubzeroAuthResult.signedIn:
          _goToDashboard();
          return;

        case SubzeroAuthResult.cancelled:
          return;

        case SubzeroAuthResult.failed:
          _toast.e('Apple sign-in failed. Please try again.');
          return;
      }
    } catch (error) {
      debugPrint('Apple sign-in failed: $error');

      if (!mounted) return;

      _toast.e('Apple sign-in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isAuthLoading) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final result = await _authService.signInWithGoogle();

      if (!mounted) return;

      switch (result) {
        case SubzeroAuthResult.signedIn:
          _goToDashboard();
          return;

        case SubzeroAuthResult.cancelled:
          return;

        case SubzeroAuthResult.failed:
          _toast.e('Google sign-in failed. Please try again.');
          return;
      }
    } catch (error) {
      debugPrint('Google sign-in failed: $error');

      if (!mounted) return;

      _toast.e('Google sign-in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  void _goToDashboard() {
    _appRoutes.pushAndPopUntil(const DashboardView(), predicate: (_) => false);
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
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0, 0.12),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: _showLoginOptions
                          ? Column(
                              key: const ValueKey('login-options'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GlassLoginPanel(
                                  isAppleLoading: _isAppleLoading,
                                  onApplePressed: _handleAppleSignIn,
                                  isGoogleLoading: _isGoogleLoading,
                                  onGooglePressed: _handleGoogleSignIn,
                                ),
                                mHeightSpan,
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
