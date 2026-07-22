import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/notification/presentation/constant/notification_constant.dart';

class KBackButton extends StatelessWidget {
  const KBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: NotificationColors.surface,
        shape: CircleBorder(
          side: BorderSide(color: NotificationColors.divider),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => locator<AppRouters>().popForced(),
          child: SizedBox(
            width: 42.w,
            height: 42.h,
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
}
