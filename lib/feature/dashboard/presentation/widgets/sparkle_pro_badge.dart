import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/theme/app_theme.dart';

class SparkleProBadge extends StatefulWidget {
  const SparkleProBadge({super.key});

  @override
  State<SparkleProBadge> createState() => _SparkleProBadgeState();
}

class _SparkleProBadgeState extends State<SparkleProBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE59A), Color(0xFFFFC94A), Color(0xFFF5A623)],
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white, width: 1.5.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5A623).withValues(alpha: 0.28),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 10.sp,
                color: primaryColor,
              ),
              3.horizontalSpace,
              KText(
                text: 'Pro',
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ],
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) {
                  return FractionalTranslation(
                    translation: Offset((_controller.value * 2.5) - 1.25, 0),
                    child: Transform.rotate(
                      angle: -0.35,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0),
                                Colors.white.withValues(alpha: 0.65),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
