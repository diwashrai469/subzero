import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/theme/app_theme.dart';

Widget addSubReminderSelector({
  required BuildContext context,
  required AddSubState state,
  required AddSubCubit cubit,
}) {
  final isPro = context.watch<ProCubit>().state.isPro;

  final reminderOptions = <ReminderOption>[
    const ReminderOption(label: 'On the day', day: 0, requiresPro: true),
    const ReminderOption(label: '1 day before', day: 1),
    const ReminderOption(label: '2 days before', day: 2, requiresPro: true),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          KText(
            text: 'Remind Me',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
      SizedBox(height: 8.h),
      KText(
        text: isPro
            ? 'Choose one or more reminder times.'
            : 'Free users receive a reminder 1 day before.',
        fontSize: 11.5.sp,
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
            final selected = state.reminderDays.contains(option.day);
            final locked = option.requiresPro && !isPro;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (locked) {
                    _showProReminderDialog(context);
                    return;
                  }

                  cubit.toggleReminderDay(option.day);
                },
                borderRadius: BorderRadius.circular(100.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? secondaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(color: borderColor),
                    boxShadow: selected
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
                      if (locked) ...[
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14.sp,
                          color: textSecondary,
                        ),
                        SizedBox(width: 5.w),
                      ],
                      KText(
                        text: option.label,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                        color: selected ? Colors.white : textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
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

void _showProReminderDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Pro reminders'),
        content: const Text(
          'Upgrade to Pro to receive reminders on the due date and two days before.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();

              // Open RevenueCat paywall here later.
            },
            child: const Text('Upgrade'),
          ),
        ],
      );
    },
  );
}
