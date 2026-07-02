import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/theme/app_theme.dart';

class KText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final bool isItalic;
  final bool isHeading;
  final double? letterSpacing;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const KText({
    super.key,
    required this.text,
    this.fontWeight,
    this.color,
    this.fontSize,
    this.textAlign,
    this.letterSpacing,
    this.textOverflow,
    this.isItalic = false,
    this.maxLines,
    this.isHeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      overflow: textOverflow,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 12.sp,
        fontFamily: fontFamily,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
