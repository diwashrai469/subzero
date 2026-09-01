import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/feature/upgrade_to_pro/presentation/upgrade_to_pro_view.dart';
import 'package:subzero/theme/app_theme.dart';

Widget addSubReminderSelector({
  required BuildContext context,
  required AddSubState state,
  required AddSubCubit cubit,
}) {
  final isPro = context.watch<ProCubit>().state.isPro;

  const reminderOptions = <ReminderOption>[
    ReminderOption(label: 'On the day', day: 0, requiresPro: true),
    ReminderOption(label: '1 day before', day: 1),
    ReminderOption(label: '2 days before', day: 2, requiresPro: true),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      KText(text: 'Remind Me', fontSize: 14.sp, fontWeight: FontWeight.w600),

      SizedBox(height: 8.h),

      KText(
        text: isPro
            ? 'Choose one or more reminder times.'
            : 'Free plan includes a reminder 1 day before.',
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),

      SizedBox(height: 10.h),

      Container(
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
          children: reminderOptions.map((option) {
            final storedSelected = state.reminderDays.contains(option.day);

            final locked = option.requiresPro && !isPro;

            // What is ACTUALLY active for the user right now.
            //
            // Pro:
            // use their saved preference.
            //
            // Free:
            // only 1 day before is active.
            final active = isPro ? storedSelected : option.day == 1;

            // The user selected this while they were Pro,
            // but it is currently inactive because they
            // no longer have Pro.
            final savedProPreference = locked && storedSelected;

            return _ReminderChip(
              option: option,
              active: active,
              locked: locked,
              savedProPreference: savedProPreference,
              onTap: () {
                if (locked) {
                  _showProReminderDialog(
                    context,
                    hasSavedPreference: savedProPreference,
                  );

                  return;
                }

                // Free users always receive the
                // 1-day-before reminder.
                //
                // Don't let them visually turn it off.
                if (!isPro && option.day == 1) {
                  return;
                }

                cubit.toggleReminderDay(option.day);
              },
            );
          }).toList(),
        ),
      ),

      if (!isPro) ...[
        SizedBox(height: 10.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 14.sp, color: textSecondary),

            SizedBox(width: 6.w),

            Expanded(
              child: KText(
                text:
                    'Your Pro reminder preferences are kept and will become active again if you upgrade.',
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ],
    ],
  );
}

class _ReminderChip extends StatelessWidget {
  final ReminderOption option;
  final bool active;
  final bool locked;
  final bool savedProPreference;
  final VoidCallback onTap;

  const _ReminderChip({
    required this.option,
    required this.active,
    required this.locked,
    required this.savedProPreference,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = active ? secondaryColor : Colors.white;

    final foregroundColor = active
        ? Colors.white
        : locked
        ? textSecondary.withValues(alpha: 0.75)
        : textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: savedProPreference
                  ? secondaryColor.withValues(alpha: 0.35)
                  : borderColor,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (active) ...[
                Icon(Icons.check_rounded, size: 14.sp, color: Colors.white),
                SizedBox(width: 5.w),
              ],

              if (locked) ...[
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14.sp,
                  color: foregroundColor,
                ),
                SizedBox(width: 5.w),
              ],

              KText(
                text: option.label,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
                color: foregroundColor,
              ),

              if (locked) ...[
                SizedBox(width: 6.w),
                _ProBadge(savedPreference: savedProPreference),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  final bool savedPreference;

  const _ProBadge({required this.savedPreference});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: secondaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: KText(
        text: savedPreference ? 'SAVED' : 'PRO',
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w800,
        color: secondaryColor,
      ),
    );
  }
}

class ReminderOption {
  final String label;
  final int day;
  final bool requiresPro;

  const ReminderOption({
    required this.label,
    required this.day,
    this.requiresPro = false,
  });
}

void _showProReminderDialog(
  BuildContext context, {
  required bool hasSavedPreference,
}) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pro icon
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: secondaryColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 30.sp,
                  color: secondaryColor,
                ),
              ),

              SizedBox(height: 16.h),

              KText(
                text: hasSavedPreference
                    ? 'Pro reminder paused'
                    : 'Unlock Pro reminders',
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: textPrimary,
              ),

              SizedBox(height: 8.h),

              KText(
                text: hasSavedPreference
                    ? 'This reminder is still saved, but it is inactive while you are on the Free plan. Upgrade to Pro to turn it back on.'
                    : 'Upgrade to Pro to get reminders on the billing day and up to 2 days before.',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                color: textSecondary,
              ),

              SizedBox(height: 18.h),

              // Feature preview
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: inputColor,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _proFeatureRow(
                      icon: Icons.today_rounded,
                      text: 'Reminder on the billing day',
                    ),
                    SizedBox(height: 10.h),
                    _proFeatureRow(
                      icon: Icons.notifications_active_rounded,
                      text: 'Reminder 2 days before',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 22.h),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textPrimary,
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: KText(
                          text: 'Not now',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) => const UpgradeToProView(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: 17.sp),
                            SizedBox(width: 6.w),
                            KText(
                              text: 'Upgrade',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _proFeatureRow({required IconData icon, required String text}) {
  return Row(
    children: [
      Container(
        width: 34.r,
        height: 34.r,
        decoration: BoxDecoration(
          color: secondaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 18.sp, color: secondaryColor),
      ),
      SizedBox(width: 10.w),
      Expanded(
        child: KText(
          text: text,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    ],
  );
}
