import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KListtile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function()? onKeyPressed;

  const KListtile(
      {super.key,
      this.leading,
      this.title,
      this.subtitle,
      this.onKeyPressed,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 3.w,
      onTap: onKeyPressed,
      visualDensity: VisualDensity(horizontal: -3.w, vertical: 2.h),
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
