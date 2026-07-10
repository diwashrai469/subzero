import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/notification/presentation/constant/notification_constant.dart';

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
      color: NotificationColors.surface,
      shape: CircleBorder(side: BorderSide(color: NotificationColors.divider)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => locator<AppRouters>().popForced(),
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 21.sp,
            color: NotificationColors.ink,
          ),
        ),
      ),
    ),
  );
}
