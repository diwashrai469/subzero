import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/theme/app_theme.dart';

Widget saveButton({
  required AddSubState state,
  required BuildContext context,
  required bool isEditing,
  required AddSubCubit cubit,
  String? existingId,
}) {
  final isLoading = state.isLoading;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: isLoading
          ? null
          : () {
              FocusScope.of(context).unfocus();
              cubit.save(existingId: existingId);
            },
      borderRadius: BorderRadius.circular(18.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: 57.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isLoading ? 0.10 : 0.22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 19.r,
                      height: 19.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2.w,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Text(
                      isEditing ? 'Updating...' : 'Saving...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('idle'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isEditing
                          ? Icons.check_circle_rounded
                          : Icons.add_circle_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 9.w),
                    Flexible(
                      child: Text(
                        isEditing ? 'Update Subscription' : 'Save Subscription',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );
}
