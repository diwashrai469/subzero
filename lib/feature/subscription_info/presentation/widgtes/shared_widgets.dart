import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/theme/app_theme.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size,
  });

  final VoidCallback onTap;
  final Widget child;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 40.r;

    return SizedBox.square(
      dimension: buttonSize + 4.r,
      child: Padding(
        padding: EdgeInsets.all(2.r),
        child: Material(
          color: Colors.white,
          shape: CircleBorder(
            side: BorderSide(color: const Color(0xFFE5E7EB), width: 1.r),
          ),
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(9.r),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return KText(
      text: label.toUpperCase(),
      fontSize: 10.5.sp,
      color: const Color(0xFF9CA3AF),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      maxLines: 1,
      textOverflow: TextOverflow.ellipsis,
    );
  }
}

class ActivePill extends StatelessWidget {
  const ActivePill({super.key, this.label = 'Active'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 24.r),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      alignment: Alignment.center,
      child: KText(
        text: label,
        fontSize: 11.sp,
        color: successColor,
        fontWeight: FontWeight.w600,
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
      ),
    );
  }
}
