import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/theme/app_theme.dart';

Widget addSubCycleSelector({
  required AddSubState state,
  required AddSubCubit cubit,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      color: inputColor,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: borderColor),
    ),
    child: Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: cycles.map((cycle) {
        final selected = cycle == state.billingCycle;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => cubit.setCycle(cycle),
            borderRadius: BorderRadius.circular(100.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: selected ? secondaryColor : Colors.white,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: borderColor),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: KText(
                text: cycle,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
