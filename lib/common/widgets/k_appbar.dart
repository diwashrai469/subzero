import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_back_button.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';

PreferredSizeWidget kAppbar({
  required String text,
  required BuildContext context,
}) {
  return AppBar(
    backgroundColor: bgColor,
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    leadingWidth: 58.w,
    leading: Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: KBackButton(),
    ),
    title: KText(
      text: text,
      textAlign: TextAlign.center,
      fontSize: 19.sp,
      fontWeight: FontWeight.w700,
      color: textPrimary,
    ),
  );
}
