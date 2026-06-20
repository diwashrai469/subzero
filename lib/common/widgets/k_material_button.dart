import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_dimens.dart';

class KMaterialButton extends StatelessWidget {
  const KMaterialButton(
      {super.key,
      required this.child,
      this.color,
      this.textColor,
      this.bordercolor,
      required this.onKeyPressed,
      this.height});
  final Widget child;
  final Color? color;
  final double? height;
  final Color? bordercolor;
  final Color? textColor;
  final void Function()? onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4).dg,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              AppDimens.globalCircularRadius,
            ),
            side: BorderSide(color: bordercolor ?? Colors.grey.shade400)),
        color: color,
        height: height,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        minWidth: 7.w,
        onPressed: onKeyPressed,
        child: child);
  }
}
