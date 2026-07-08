import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/category_picker.dart';

Future<void> openCategoryPicker({
  required AddSubState state,
  required BuildContext context,
  required AddSubCubit cubit,
}) async {
  final selectedCategory = await Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (_) => CategoryPicker(selectedCategory: state.category),
    ),
  );

  if (!context.mounted || selectedCategory == null) return;

  cubit.setCategory(selectedCategory);
}

Widget addSubCategorySelector({
  required AddSubState state,
  required BuildContext context,
  required AddSubCubit cubit,
}) {
  final selectedCategory = categoriesList.firstWhere(
    (cat) => cat.label == state.category,
    orElse: () => categoriesList.first,
  );

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () =>
          openCategoryPicker(state: state, context: context, cubit: cubit),
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        width: double.infinity,
        padding: EdgeInsets.all(13.r),
        decoration: BoxDecoration(
          color: inputColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: selectedCategory.iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: selectedCategory.iconColor.withValues(alpha: 0.24),
                ),
              ),
              child: Center(
                child: Image.asset(
                  selectedCategory.emoji,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(width: 13.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCategory.label,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 15.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Tap to choose another category',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13.sp,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
