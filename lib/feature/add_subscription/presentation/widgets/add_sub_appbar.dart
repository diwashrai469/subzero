import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';

PreferredSizeWidget addSubAppbar(
  bool isEditing,
  BuildContext context,
  Color bgColor,
) {
  return AppBar(
    backgroundColor: bgColor,
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    leadingWidth: 58.w,
    leading: Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: _roundIconButton(
        icon: Icons.arrow_back_rounded,
        onTap: () => locator<AppRouters>().popForced(),
      ),
    ),
    title: KText(
      text: isEditing ? 'Edit Subscription' : 'Add Subscription',
      fontSize: 21.sp,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
    ),
  );
}

Widget _roundIconButton({required IconData icon, required VoidCallback onTap}) {
  return Center(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.r),
        child: Ink(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, size: 20.sp),
        ),
      ),
    ),
  );
}
