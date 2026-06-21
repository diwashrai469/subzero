import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';

class LoginLegalText extends StatelessWidget {
  const LoginLegalText({super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: 11.sp,
      color: AuthPalette.textTertiary,
      height: 1.5,
    );

    final linkStyle = baseStyle.copyWith(
      color: AuthPalette.textSecondary,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text.rich(
        TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: AuthCopy.legalPrefix),
            TextSpan(text: AuthCopy.terms, style: linkStyle),
            const TextSpan(text: AuthCopy.legalMiddle),
            TextSpan(text: AuthCopy.privacyPolicy, style: linkStyle),
            const TextSpan(text: AuthCopy.legalSuffix),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
