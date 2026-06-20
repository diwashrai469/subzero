import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/theme/app_theme.dart';

import 'k_loading_indicator.dart';

class KLoader {
  static Future<dynamic> showMyLoader(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (contex) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              alignment: Alignment.center,
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20).r,
              ),
              child: kLoadingIndicator(
                context: context,
                background: primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
