import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';

Widget _inputBox({required Widget child, EdgeInsetsGeometry? padding}) {
  return Container(
    width: double.infinity,
    padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: inputColor,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: borderColor),
    ),
    child: child,
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.grey.shade400,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    isDense: true,
    contentPadding: EdgeInsets.zero,
  );
}

Widget addSubTextField({
  required TextEditingController controller,
  required String hint,
  required ValueChanged<String> onChanged,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  IconData? prefixIcon,
  bool compact = false,
}) {
  return _inputBox(
    padding: EdgeInsets.symmetric(
      horizontal: 12.w,
      vertical: compact ? 9.h : 10.h,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          Container(
            width: compact ? 28.r : 30.r,
            height: compact ? 28.r : 30.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(color: borderColor),
            ),
            child: Icon(
              prefixIcon,
              size: compact ? 15.sp : 16.sp,
              color: textSecondary,
            ),
          ),
          SizedBox(width: 10.w),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            showCursor: true,
            enableInteractiveSelection: true,
            onChanged: (value) {
              onChanged(value);
            },
            style: TextStyle(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w700,
            ),
            decoration: _inputDecoration(hint),
          ),
        ),
      ],
    ),
  );
}
