import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/core/services/toast/toast_service.dart';

class UpgradeToProView extends StatefulWidget {
  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  const UpgradeToProView({
    super.key,
    this.onTermsPressed,
    this.onPrivacyPressed,
  });

  @override
  State<UpgradeToProView> createState() => _UpgradeToProViewState();
}

class _UpgradeToProViewState extends State<UpgradeToProView> {
  bool _isPurchasing = false;

  static const List<_ProFeature> _features = [
    _ProFeature(
      icon: Icons.all_inclusive_rounded,
      title: 'Unlimited subscriptions',
      description:
          'Create and manage as many recurring subscriptions as you need.',
    ),
    _ProFeature(
      icon: Icons.insights_rounded,
      title: 'Monthly and yearly summaries',
      description:
          'See your total subscription spending at a glance each month and year.',
    ),
    _ProFeature(
      icon: Icons.trending_up_rounded,
      title: 'Biggest subscription insights',
      description: 'Quickly identify which subscription costs you the most.',
    ),
    _ProFeature(
      icon: Icons.notifications_active_rounded,
      title: 'Custom reminder timing',
      description:
          'Choose reminders for today, tomorrow, or two days before a payment.',
    ),
    _ProFeature(
      icon: Icons.history_rounded,
      title: 'Notification history',
      description:
          'View your previous reminders so you never lose track of a payment.',
    ),
  ];

  Future<void> _handleUpgrade() async {
    if (_isPurchasing) return;

    final confirmed = await _showPurchaseConfirmationDialog();

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _isPurchasing = true;
    });

    await WidgetsBinding.instance.endOfFrame;

    HapticFeedback.mediumImpact();

    try {
      final purchased = await context.read<ProCubit>().purchaseLifetime();

      if (!mounted) return;

      if (!purchased) {
        locator<ToastService>().e('Purchase was cancelled.');
        return;
      }

      locator<AppRouters>().popForced();
    } catch (error) {
      if (!mounted) return;

      debugPrint('❌ Lifetime purchase failed: $error');

      locator<ToastService>().e(
        'Purchase could not be completed. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  Future<bool?> _showPurchaseConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Container(
            padding: EdgeInsets.all(22.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 62.r,
                  height: 62.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    size: 32.sp,
                    color: const Color(0xFF175CD3),
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  'Before you continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: const Color(0xFF101828),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Your purchase will use the Apple Account currently signed in on this device.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF667085),
                  ),
                ),

                SizedBox(height: 18.h),

                _infoRow(
                  icon: Icons.payments_outlined,
                  title: 'Already purchased?',
                  description:
                      'If this Apple Account already owns SubZero Pro, you should not be charged again.',
                ),

                SizedBox(height: 10.h),

                _infoRow(
                  icon: Icons.swap_horiz_rounded,
                  title: 'Pro access may transfer',
                  description:
                      'If the purchase is linked to another SubZero account, Pro access may move to this account.',
                ),

                SizedBox(height: 10.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EB),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFFFE0A3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 19.sp,
                        color: const Color(0xFFB54708),
                      ),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: Text(
                          'If Pro is transferred, the previous SubZero account may no longer have Pro access.',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7A2E0E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF344054),
                            side: const BorderSide(color: Color(0xFFD0D5DD)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF175CD3),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE7ECF4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(icon, size: 20.sp, color: const Color(0xFF175CD3)),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF101828),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Stack(
        children: [
          const Positioned.fill(child: _UpgradeBackground()),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 30.h),
                    child: Column(
                      children: [
                        _buildHeroSection(),
                        SizedBox(height: 18.h),
                        _buildPricingCard(),
                        SizedBox(height: 18.h),
                        _buildFeaturesCard(),
                        SizedBox(height: 20.h),
                        _buildUpgradeButton(),
                        SizedBox(height: 18.h),
                        _buildPurchaseInformation(),
                        SizedBox(height: 14.h),
                        _buildLegalLinks(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 18.w, 4.h),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.82),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: Navigator.of(context).pop,
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(
                  Icons.close_rounded,
                  size: 22.sp,
                  color: const Color(0xFF172033),
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  size: 16.sp,
                  color: const Color(0xFFB7791F),
                ),
                SizedBox(width: 5.w),
                Text(
                  'SUBZERO PRO',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: const Color(0xFF172033),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
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
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(AppImage.appIcon, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 18.r,
                height: 18.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD166),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: 12.sp,
                  color: const Color(0xFF594000),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          'Unlock SubZero Pro',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27.sp,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
            color: const Color(0xFF101828),
          ),
        ),
        SizedBox(height: 9.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Take full control of your subscriptions, spending and payment reminders.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF667085),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF082F5B), Color(0xFF0A4177), Color(0xFF122A56)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF082F5B).withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  'LIFETIME ACCESS',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                    color: const Color(0xFF5C4300),
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.verified_rounded,
                color: const Color(0xFF7CE4FF),
                size: 23.sp,
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$14.99',
                style: TextStyle(
                  fontSize: 38.sp,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 7.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          Row(
            children: [
              Icon(
                Icons.done_rounded,
                size: 17.sp,
                color: const Color(0xFF7CE4FF),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'One-time payment. No recurring subscription.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE7ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Everything included',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF101828),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Upgrade once and unlock every Pro feature.',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF667085)),
          ),
          SizedBox(height: 17.h),
          for (int index = 0; index < _features.length; index++) ...[
            _FeatureTile(feature: _features[index]),
            if (index < _features.length - 1)
              Padding(
                padding: EdgeInsets.only(left: 51.w),
                child: Divider(height: 22.h, color: const Color(0xFFEEF1F6)),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return Container(
      width: double.infinity,
      height: 57.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF176BDB), Color(0xFF3257D6), Color(0xFF694FD6)],
        ),
      ),
      child: ElevatedButton(
        onPressed: _isPurchasing ? null : _handleUpgrade,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.r),
          ),
        ),
        child: _isPurchasing
            ? SizedBox(
                width: 23.r,
                height: 23.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 21.sp,
                  ),
                  SizedBox(width: 9.w),
                  Text(
                    'Unlock Pro for \$14.99',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPurchaseInformation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 18.sp,
            color: const Color(0xFF175CD3),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'Your purchase is securely processed through the App Store.',
              style: TextStyle(
                fontSize: 10.5.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF344054),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLinks() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        _LegalButton(label: 'Terms of Use', onPressed: widget.onTermsPressed),
        Text(
          ' • ',
          style: TextStyle(fontSize: 10.sp, color: const Color(0xFF98A2B3)),
        ),
        _LegalButton(
          label: 'Privacy Policy',
          onPressed: widget.onPrivacyPressed,
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _ProFeature feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Icon(
            feature.icon,
            size: 21.sp,
            color: const Color(0xFF175CD3),
          ),
        ),
        SizedBox(width: 11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101828),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                feature.description,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  height: 1.45,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpgradeBackground extends StatelessWidget {
  const _UpgradeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ColoredBox(color: Color(0xFFF5F7FB)),
        Positioned(
          top: -110,
          right: -100,
          child: _BlurredCircle(
            size: 260,
            color: const Color(0xFF84D7FF).withValues(alpha: 0.28),
          ),
        ),
      ],
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurredCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _LegalButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _LegalButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        minimumSize: Size.zero,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5.sp,
          color: const Color(0xFF667085),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _ProFeature {
  final IconData icon;
  final String title;
  final String description;

  const _ProFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}
