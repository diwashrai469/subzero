import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_appbar.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _cubit.markAllAsSeen();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
          appBar: kAppbar(text: 'Notifications', context: context),
          backgroundColor: NotificationColors.background,
          body: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: NotificationColors.ink,
                    strokeWidth: 2,
                  ),
                );
              }

              if (state.notifications.isEmpty && state.errorMessage != null) {
                return _NotificationErrorView(
                  message: state.errorMessage!,
                  onRetry: _cubit.load,
                );
              }

              return RefreshIndicator(
                onRefresh: _cubit.refresh,
                color: NotificationColors.ink,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    if (state.notifications.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: NotificationEmptyStateView(),
                      )
                    else ...[
                      _NotificationList(notifications: state.notifications),

                      if (state.hasMore)
                        SliverToBoxAdapter(
                          child: _LoadMoreButton(
                            loading: state.loadingMore,
                            onPressed: _cubit.loadMore,
                          ),
                        ),

                      if (!state.hasMore)
                        const SliverToBoxAdapter(child: _AllCaughtUpMessage()),

                      if (state.errorMessage != null)
                        SliverToBoxAdapter(
                          child: _PaginationErrorMessage(
                            message: state.errorMessage!,
                          ),
                        ),
                    ],

                    SliverToBoxAdapter(child: SizedBox(height: 32.h)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({required this.notifications});

  final List<AppNotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotifications(notifications);
    final groups = groupedNotifications.entries.toList();

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final group = groups[index];
          final label = group.key;
          final notifications = group.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 0 : 24.h,
                  bottom: 12.h,
                ),
                child: KText(
                  text: label.toUpperCase(),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: NotificationColors.subtext,
                  letterSpacing: 0.9,
                ),
              ),
              ...notifications.map((notification) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _NotificationCard(notification: notification),
                );
              }),
            ],
          );
        }, childCount: groups.length),
      ),
    );
  }

  Map<String, List<AppNotificationModel>> _groupNotifications(
    List<AppNotificationModel> notifications,
  ) {
    final grouped = <String, List<AppNotificationModel>>{};

    for (final notification in notifications) {
      final label = _dateLabel(notification.createdAt);

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(notification);
    }

    return grouped;
  }

  String _dateLabel(DateTime date) {
    final localDate = date.toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final notificationDay = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    final yesterday = today.subtract(const Duration(days: 1));

    if (notificationDay == today) {
      return 'Today';
    }

    if (notificationDay == yesterday) {
      return 'Yesterday';
    }

    return '${localDate.day} '
        '${month(localDate.month)} '
        '${localDate.year}';
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final AppNotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final categoryData = SubscriptionCategoryHelper.getCategory(
      notification.category,
    );

    return Container(
      decoration: BoxDecoration(
        color: NotificationColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: notification.isSeen
            ? null
            : Border.all(color: NotificationColors.ink.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!notification.isSeen)
                Container(width: 3.w, color: NotificationColors.ink),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 15.h, 14.w, 15.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        categoryData.emoji,
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
                              fontWeight: FontWeight.w600,
                              color: NotificationColors.ink,
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

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 0),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: NotificationColors.ink,
            backgroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFDCE2EA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: loading
                ? SizedBox(
                    key: const ValueKey('loadingMore'),
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: NotificationColors.ink,
                    ),
                  )
                : Row(
                    key: const ValueKey('loadMore'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KText(
                        text: 'Load more',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: NotificationColors.ink,
                      ),
                      SizedBox(width: 7.w),
                      Icon(Icons.expand_more_rounded, size: 20.sp),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _AllCaughtUpMessage extends StatelessWidget {
  const _AllCaughtUpMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: Center(
        child: KText(
          text: 'You’re all caught up',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: NotificationColors.subtext,
        ),
      ),
    );
  }
}

class _PaginationErrorMessage extends StatelessWidget {
  const _PaginationErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: KText(
        text: 'Could not load more notifications. Please try again.',
        textAlign: TextAlign.center,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Colors.red.shade700,
      ),
    );
  }
}

class _NotificationErrorView extends StatelessWidget {
  const _NotificationErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42.sp,
              color: Colors.red.shade600,
            ),
            SizedBox(height: 12.h),
            KText(
              text: 'Could not load notifications',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: NotificationColors.ink,
            ),
            SizedBox(height: 7.h),
            KText(
              text: 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: NotificationColors.subtext,
            ),
            SizedBox(height: 18.h),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
