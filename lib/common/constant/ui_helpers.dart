import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// These are a bunch of padding and spacing helpers, to facilitate fast writing of spacings,
/// as well as make a bunch of speed optimizations due to constant value during rebuild.

// ---- Vertical Spacing ----
final xxsHeightSpan = SizedBox(height: 2.h);
final xsHeightSpan = SizedBox(height: 4.h);
final sHeightSpan = SizedBox(height: 8.h);
final mHeightSpan = SizedBox(height: 16.h);
final lHeightSpan = SizedBox(height: 24.h);
final elHeightSpan = SizedBox(height: 48.h);

// ---- Horizontal Spacing ----
final xxsWidthSpan = SizedBox(width: 2.w);
final xsWidthSpan = SizedBox(width: 4.w);
final sWidthSpan = SizedBox(width: 8.w);
final mWidthSpan = SizedBox(width: 16.w);
final lWidthSpan = SizedBox(width: 24.w);
final elWidthSpan = SizedBox(width: 48.w);

// ---- Page Paddings ----
const lPagePadding = EdgeInsets.symmetric(horizontal: 64);
const mPagePadding = EdgeInsets.symmetric(horizontal: 32);
const mXPagePadding = EdgeInsets.symmetric(horizontal: 32);
const mYPagePadding = EdgeInsets.symmetric(vertical: 32);
const sXPagePadding = EdgeInsets.symmetric(horizontal: 16);
const sYPagePadding = EdgeInsets.symmetric(vertical: 16);
const sPagePadding = EdgeInsets.all(16);

// ---- Container Padding ----
const sPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 8);
const sXPadding = EdgeInsets.symmetric(horizontal: 8);
const xsYPadding = EdgeInsets.symmetric(vertical: 4);
const sYPadding = EdgeInsets.symmetric(vertical: 8);
const mPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
const mXPadding = EdgeInsets.symmetric(horizontal: 12);
const mYPadding = EdgeInsets.symmetric(vertical: 12);
const lPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 18);
const lXPadding = EdgeInsets.symmetric(horizontal: 18);
const lYPadding = EdgeInsets.symmetric(vertical: 18);

const xlPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 24);
const xlXPadding = EdgeInsets.symmetric(horizontal: 24);
const xlYPadding = EdgeInsets.symmetric(vertical: 24);

const xxlPadding = EdgeInsets.symmetric(vertical: 32, horizontal: 32);
