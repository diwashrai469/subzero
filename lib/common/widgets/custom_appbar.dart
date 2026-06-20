import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';

AppBar customAppbar({required String title, List<Widget>? actions}) {
  return AppBar(
    actions: actions,
    title: KText(
      text: title,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
