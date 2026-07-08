import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';

import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/subscription_category.dart';
import 'package:subzero/feature/notification/model/notification_model.dart';
import 'package:subzero/feature/notification/presentation/constant/notification_constant.dart';
import 'package:subzero/feature/notification/presentation/cubit/notification_cubit.dart';
import 'package:subzero/feature/notification/presentation/cubit/notification_state.dart';
import 'package:subzero/feature/notification/presentation/widgets/notification_empty_state_view.dart';

@RoutePage()
class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = locator<NotificationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cubit.markAllAsSeen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: NotificationColors.background,
          body: SafeArea(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: NotificationColors.ink,
                      strokeWidth: 2,
                    ),
                  );
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _Header()),

                    if (state.notifications.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: NotificationEmptyStateView(),
                      )
                    else
                      _NotificationList(notifications: state.notifications),

                    SliverToBoxAdapter(child: SizedBox(height: 32.h)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 44.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: NotificationColors.surface,
                    shape: CircleBorder(
                      side: BorderSide(color: NotificationColors.divider),
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 42.w,
                        height: 42.w,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 21.sp,
                          color: NotificationColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
                KText(
                  text: 'Notifications',
                  fontSize: 21.sp,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({required this.notifications});

  final List<AppNotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    final grouped = _group(notifications);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
          final label = grouped.keys.elementAt(i);
          final items = grouped[label]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 24.h, bottom: 12.h),
                child: KText(
                  text: label.toUpperCase(),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: NotificationColors.subtext,
                  letterSpacing: 0.9,
                ),
              ),
              ...items.map(
                (n) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _NotificationCard(notification: n),
                ),
              ),
            ],
          );
        }, childCount: grouped.length),
      ),
    );
  }

  Map<String, List<AppNotificationModel>> _group(
    List<AppNotificationModel> list,
  ) {
    final grouped = <String, List<AppNotificationModel>>{};
    for (final n in list) {
      final key = _label(n.createdAt);
      grouped.putIfAbsent(key, () => []).add(n);
    }
    return grouped;
  }

  String _label(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day} ${month(date.month)} ${date.year}';
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final AppNotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final data = SubscriptionCategoryHelper.getCategory(notification.category);

    return Container(
      decoration: BoxDecoration(
        color: NotificationColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 15.h, 14.w, 15.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        data.emoji,
                        width: 32.w,
                        height: 32.w,
                        fit: BoxFit.contain,
                      ),
                      mWidthSpan,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: notification.title,
                              fontSize: 14.5.sp,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w800,
                              color: NotificationColors.ink,
                              letterSpacing: -0.2,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                            xsHeightSpan,
                            KText(
                              text: notification.body,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              color: NotificationColors.subtext,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
