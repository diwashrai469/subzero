import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App Dimensions class to reuse values that are used throughout the layout
/// Using a single source of dimensions will create robust ui development,
/// and also make design changes easier.
///

class AppDimens {
  //screenutils
  static const appHeight =
      896.0; //"Add your custom height of screen with mediaQuery";
  static const appWidth =
      414.0; //"Add your custom width of screen with mediaQuery";

  //page padding
  static final mainPagePadding = const EdgeInsets.only(
    right: 16,
    left: 16,
    top: 7,
  ).dg;

  //circle avatar radius
  static final sssCircleAvatarRadius = 12.0.r;
  static final ssCircleAvatarRadius = 15.0.r;
  static final sCircleAvatarRadius = 17.0.r;
  static final mCircleAvatarRadius = 20.0.r;
  static final lCircleAvatarRadius = 25.0.r;
  static final elCircleAvatarRadius = 30.0.r;
  static final boarderAvatarCircleRaduis = 26.0.r;

  static final pagePadding = const EdgeInsets.all(20).dg;
  static final pagePaddingX = EdgeInsets.symmetric(horizontal: 20.w);
  static final pagePaddingY = const EdgeInsets.symmetric(vertical: 20).h;
  static final pagePaddingLarge = const EdgeInsets.all(32).h;

  static final globalCircularRadius = const Radius.circular(12.0).r;

  static const cardRadius = 0.0;
  static const cardBorderRadius = BorderRadius.all(Radius.circular(cardRadius));
  static const double cardPaddingSize = 20;
  static const cardPadding = EdgeInsets.all(cardPaddingSize);
  static const inputBorderRadius = BorderRadius.all(Radius.circular(0));
  static final inputPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 8.h,
  );
  static final chipPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 4.h,
  );
  static final buttonFontSizeXSmall = 14.0.h;
  static final buttonFontSizeSmall = 15.0.h;
  static final buttonFontSizeMedium = 16.0.h;
  static final buttonFontSizeLarge = 17.0.h;

  static final iconButtonSizeSmall = 24.0.h;
  static final iconButtonSizeLarge = 32.0.h;

  //boarder radius
  static final sboarderRadisCircular = 8.0.r;

  static final buttonPaddingXSmall = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 8.h,
  );
  static final buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 12.h,
  );
  static final buttonPaddingMedium = EdgeInsets.symmetric(
    horizontal: 22.w,
    vertical: 16.h,
  );
  static final buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: 32.w,
    vertical: 24.h,
  );

  static final double titleFontSize = 16.sp;

  //text fontweight
  static const FontWeight sfontweight = FontWeight.w300;
  static const FontWeight mfontweight = FontWeight.w500;
  static const FontWeight lfontweight = FontWeight.w700;

  //text fontsize
  static final double headlineFontSizeXXXSmall = 10.sp;
  static final double headlineFontSizeXXSmall = 12.sp;
  static final double headlineFontSizeXSmall = 14.sp;
  static final double headlineFontSizeSSmall = 16.sp;
  static final double headlineFontSizeSmall1 = 18.sp;
  static final double headlineFontSizeSmall = 20.sp;
  static final double headlineFontSizeOther = 22.sp;
  static final double headlineFontSizeMedium = 28.sp;
  static final double headlineFontSizeLarge = 32.sp;

  static const double multiSelectPadding = 8;
}
