import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:subzero/common/constant/app_image.dart';

import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/dashboard_helpers.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/delete_sub_dialog.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/subscription_category.dart';
import 'package:subzero/theme/app_theme.dart';

class SubRow extends StatefulWidget {
  final SubscriptionModel sub;

  const SubRow({super.key, required this.sub});

  @override
  State<SubRow> createState() => _SubRowState();
}

class _SubRowState extends State<SubRow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _heroTag => 'subscription-hero-${widget.sub.id}';

  @override
  Widget build(BuildContext context) {
    final dueText = dueTextHelper(widget.sub);

    final isUrgent =
        dueText == 'Due today' ||
        dueText == 'Due tomorrow' ||
        dueText == 'Due in 2d';

    final selectedCategory = categoriesList.firstWhere(
      (cat) => cat.label == widget.sub.category,
      orElse: () => categoriesList.first,
    );

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Slidable(
          key: ValueKey(widget.sub.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.46,
            children: [
              CustomSlidableAction(
                onPressed: (_) => locator<AppRouters>().push(
                  AddSubscriptionView(existingSub: widget.sub),
                ),
                backgroundColor: const Color(0xFFEEF2FF),
                foregroundColor: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.editIcon,
                      width: 20.r,
                      height: 20.r,
                      fit: BoxFit.contain,
                      color: Color(0xFF4F46E5),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
              CustomSlidableAction(
                onPressed: (_) =>
                    deleteSubDialog(context: context, sub: widget.sub),

                backgroundColor: const Color(0xFFFFEBEE),
                foregroundColor: errorColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.deleteIcon,
                      width: 18.r,
                      height: 18.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => locator<AppRouters>().push(
                SubscriptionInfoView(sub: widget.sub),
              ),

              borderRadius: BorderRadius.circular(14.r),
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 12,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: _heroTag,
                      flightShuttleBuilder:
                          (
                            flightContext,
                            animation,
                            flightDirection,
                            fromHeroContext,
                            toHeroContext,
                          ) {
                            return ScaleTransition(
                              scale: Tween<double>(begin: 0.96, end: 1.0)
                                  .animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                              child: Material(
                                color: Colors.transparent,
                                child: toHeroContext.widget,
                              ),
                            );
                          },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: selectedCategory.iconColor.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: selectedCategory.iconColor.withValues(
                                alpha: 0.24,
                              ),
                            ),
                          ),
                          child: Center(
                            child: SubscriptionCategoryIcon(
                              category: widget.sub.category,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),

                    mWidthSpan,

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: KText(
                                  text: widget.sub.name,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: isUrgent
                                      ? Colors.orange
                                      : const Color(0xFF50987A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),

                          xxsHeightSpan,

                          KText(
                            text: 'Next: $dueText',
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        KText(
                          text:
                              '${widget.sub.currency}${widget.sub.amount.toStringAsFixed(2)}',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        xxsHeightSpan,
                        KText(
                          text: widget.sub.billingCycle,
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
