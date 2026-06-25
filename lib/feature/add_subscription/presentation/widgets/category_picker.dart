import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';

class CategoryPicker extends StatelessWidget {
  final String selectedCategory;

  const CategoryPicker({super.key, required this.selectedCategory});

  static const Color bgColor = Color(0xFFF6F7F9);
  static const Color inputColor = Color(0xFFF9FAFB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 58.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(100.r),
                child: Ink(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 20.sp,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Choose Category',
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: textPrimary,
          ),
        ),
      ),
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
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pick the best match',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5.sp,
                            height: 1.18,
                            fontWeight: FontWeight.w900,
                            color: textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'This helps Subzero organise your subscriptions and keep your dashboard clean.',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

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

                            SizedBox(height: 8.h),

                            Text(
                              cat.label,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 10.8.sp,
                                height: 1.15,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: selected ? textPrimary : textSecondary,
                              ),
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
