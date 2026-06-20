import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';

class KError extends StatelessWidget {
  final Function()? onTap;
  const KError({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 40,
                child: Icon(
                  size: 40.h,
                  Icons.refresh_sharp,
                  color: Colors.black,
                ),
              ),
            ),
            sHeightSpan,
            const KText(
              text:
                  "We're sorry, but something went wrong.\n Please try again.",
            ),
          ],
        ),
      ),
    );
  }
}
