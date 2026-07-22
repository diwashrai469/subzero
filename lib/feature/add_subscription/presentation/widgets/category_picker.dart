import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/common/widgets/k_appbar.dart';

class CategoryPicker extends StatelessWidget {
  final String selectedCategory;

  const CategoryPicker({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: kAppbar(text: 'Pick a Category', context: context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.035),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.category_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  sWidthSpan,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KText(
                          text: 'Pick the best match',
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                        xsHeightSpan,
                        KText(
                          text:
                              'This helps Subzero organise your subscriptions and keep your dashboard clean.',
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: textSecondary,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            mHeightSpan,

            _categoryGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _categoryGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width < 310
            ? 2
            : width < 390
            ? 3
            : 4;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoriesList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: crossAxisCount == 2 ? 1.25 : 0.95,
          ),
          itemBuilder: (_, index) {
            final cat = categoriesList[index];
            final selected = cat.label == selectedCategory;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context, cat.label),
                borderRadius: BorderRadius.circular(18.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? cat.iconColor.withValues(alpha: 0.10)
                        : inputColor,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: selected ? cat.iconColor : borderColor,
                      width: selected ? 1.7 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: cat.iconColor.withValues(alpha: 0.12),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Stack(
                    children: [
                      if (selected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 19.r,
                            height: 19.r,
                            decoration: BoxDecoration(
                              color: cat.iconColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 65.w,
                              height: 65.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                  color: selected
                                      ? cat.iconColor.withValues(alpha: 0.25)
                                      : borderColor,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  cat.emoji,
                                  width: 40.w,
                                  height: 40.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            sHeightSpan,

                            KText(
                              text: cat.label,
                              textAlign: TextAlign.center,
                              fontSize: 12.sp,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: selected ? textPrimary : textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
