import 'package:flutter/material.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionCategoryHelper {
  static SubscriptionCategoryModel getCategory(String categoryName) {
    return categoriesList.firstWhere(
      (e) => e.label.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => categoriesList.last,
    );
  }
}

class SubscriptionCategoryIcon extends StatelessWidget {
  final String category;
  final double? size;

  const SubscriptionCategoryIcon({
    super.key,
    required this.category,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final data = SubscriptionCategoryHelper.getCategory(category);

    return Image.asset(
      data.emoji,
      width: size ?? 32.w,
      height: size ?? 32.w,
      fit: BoxFit.contain,
    );
  }
}
