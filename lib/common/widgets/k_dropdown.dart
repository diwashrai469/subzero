import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/theme/app_theme.dart';

Widget kDropDown({
  String? dropdownvalue,
  bool? isExpanded,
  String? label,
  bool? isRequired,
  required List<DropdownMenuItem<String>>? items,
  required void Function(String?)? onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      border: Border.all(color: primaryColor),
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10).r,
    ),
    child: DropdownButton(
      isExpanded: isExpanded ?? false,
      borderRadius: BorderRadius.circular(8).r,
      value: dropdownvalue,
      underline: const SizedBox(),
      // style: appTextStyle,
      icon: const Icon(Icons.arrow_drop_down),
      items: items,
      iconSize: 30.h,
      onChanged: onChanged,
    ),
  );
}
