import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:subzero/common/constant/amount_format_helper.dart';
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
import 'package:subzero/theme/app_theme.dart';

class SubRow extends StatefulWidget {
  const SubRow({super.key, required this.sub});

  final SubscriptionModel sub;

  @override
  State<SubRow> createState() => _SubRowState();
}

class _SubRowState extends State<SubRow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final Color editColor = const Color(0xFF4F46E5);

  String get _heroTag => 'subscription-hero-${widget.sub.id}';

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

  @override
  Widget build(BuildContext context) {
    final dueText = dueTextHelper(widget.sub);

    final isUrgent =
        dueText == 'Due today' ||
        dueText == 'Due tomorrow' ||
        dueText == 'Due in 2d';

    final selectedCategory = categoriesList.firstWhere(
      (category) => category.label == widget.sub.category,
      orElse: () => categoriesList.first,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 340;

        final cardPadding = isSmallScreen ? 9.w : 12.w;
        final iconBoxSize = isSmallScreen ? 40.r : 44.r;
        final horizontalGap = isSmallScreen ? 8.w : 12.w;
        final amountMaxWidth = isSmallScreen ? 82.w : 105.w;

        return FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Slidable(
              key: ValueKey(widget.sub.id),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: isSmallScreen ? 0.55 : 0.46,
                children: [
                  _SlidableItem(
                    label: 'Edit',
                    imagePath: AppImage.editIcon,
                    foregroundColor: editColor,
                    backgroundColor: const Color(0xFFEEF2FF),
                    imageColor: editColor,
                    onPressed: () {
                      locator<AppRouters>().push(
                        AddSubscriptionView(existingSub: widget.sub),
                      );
                    },
                  ),
                  _SlidableItem(
                    label: 'Delete',
                    imagePath: AppImage.deleteIcon,
                    foregroundColor: errorColor,
                    backgroundColor: const Color(0xFFFFEBEE),
                    onPressed: () {
                      deleteSubDialog(context: context, sub: widget.sub);
                    },
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    locator<AppRouters>().push(
                      SubscriptionInfoView(sub: widget.sub),
                    );
                  },
                  borderRadius: BorderRadius.circular(14.r),
                  child: Ink(
                    padding: EdgeInsets.symmetric(
                      horizontal: cardPadding,
                      vertical: isSmallScreen ? 9.h : 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 0.8.r,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.035),
                          blurRadius: 12.r,
                          offset: Offset(0, 7.h),
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
                                  scale: Tween<double>(begin: 0.96, end: 1)
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
                            child: SizedBox.square(
                              dimension: iconBoxSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: selectedCategory.iconColor.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: selectedCategory.iconColor
                                        .withValues(alpha: 0.24),
                                    width: 1.r,
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
                            ),
                          ),
                        ),

                        SizedBox(width: horizontalGap),

                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: KText(
                                      text: widget.sub.name,
                                      fontSize: isSmallScreen ? 12.sp : 14.2.sp,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  SizedBox.square(
                                    dimension: 6.r,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: isUrgent
                                            ? Colors.orange
                                            : const Color(0xFF50987A),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),
                              KText(
                                text: 'Next: $dueText',
                                fontSize: isSmallScreen ? 9.sp : 10.sp,
                                color: disabledColor,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: isSmallScreen ? 6.w : 10.w),

                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: amountMaxWidth),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: KText(
                                  text: AmountFormatHelper.formatCurrency(
                                    widget.sub.amount,
                                    widget.sub.currency,
                                  ),
                                  fontSize: isSmallScreen ? 12.sp : 14.5.sp,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 1,
                                ),
                              ),
                              xxsHeightSpan,
                              KText(
                                text: widget.sub.billingCycle,
                                fontSize: isSmallScreen ? 9.sp : 10.sp,
                                color: disabledColor,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SlidableItem extends StatelessWidget {
  const _SlidableItem({
    required this.label,
    required this.imagePath,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onPressed,
    this.imageColor,
  });

  final String label;
  final String imagePath;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color? imageColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = constraints.maxWidth < 55 ? 17.r : 20.r;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                color: imageColor,
              ),
              xsHeightSpan,
              KText(
                text: label,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}
