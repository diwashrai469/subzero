import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';
import 'package:subzero/feature/dashboard/presentation/widgets/delete_sub_dialog.dart';
import 'package:subzero/feature/subscription_info/presentation/cubit/subscription_info_cubit.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/cost_breakdown_card.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/hero_header.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/info_card.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/shared_widgets.dart';
import 'package:subzero/feature/subscription_info/presentation/widgtes/utils.dart';

@RoutePage()
class SubscriptionInfoView extends StatelessWidget {
  final SubscriptionModel sub;

  const SubscriptionInfoView({super.key, required this.sub});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionInfoCubit(sub),
      child: _SubscriptionInfoBody(sub: sub),
    );
  }
}

class _SubscriptionInfoBody extends StatelessWidget {
  final SubscriptionModel sub;

  const _SubscriptionInfoBody({required this.sub});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SubscriptionInfoCubit>().state;
    final urgency = SubscriptionInfoCubit.urgencyColor(state.daysUntilBilling);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 265.h,
            pinned: false,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: const Color(0xFFF5F5F7),
            leading: NavButton(
              onTap: () => locator<AppRouters>().popForced(),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFF374151),
                size: 18.sp,
              ),
            ),
            actions: [
              NavButton(
                onTap: () => locator<AppRouters>().push(
                  AddSubscriptionView(existingSub: sub),
                ),
                child: Image.asset(AppImage.editIcon, fit: BoxFit.contain),
              ),

              NavButton(
                onTap: () => deleteSubDialog(context: context, sub: sub),
                child: Image.asset(AppImage.deleteIcon),
              ),

              SizedBox(width: 10.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: HeroHeader(
                sub: sub,
                daysUntilBilling: state.daysUntilBilling,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel(label: 'Cost Breakdown'),
                  SizedBox(height: 10.h),
                  CostBreakdownCard(
                    currency: sub.currency,
                    daily: state.dailyEquivalent,
                    monthly: state.monthlyEquivalent,
                    yearly: state.yearlyEquivalent,
                  ),

                  SizedBox(height: 22.h),

                  const SectionLabel(label: 'Billing Details'),
                  SizedBox(height: 10.h),
                  InfoCard(
                    rows: [
                      InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'First Billed',
                        value: formatDate(sub.firstBillDate),
                      ),
                      InfoRow(
                        icon: Icons.event_outlined,
                        label: 'Next Bill',
                        value: formatDate(state.nextBillDate),
                        valueColor: urgency,
                      ),
                      InfoRow(
                        icon: Icons.repeat_outlined,
                        label: 'Billing Cycle',
                        value: capitalize(sub.billingCycle),
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  const SectionLabel(label: 'Subscription Info'),
                  SizedBox(height: 10.h),
                  InfoCard(
                    rows: [
                      InfoRow(
                        icon: Icons.sell_outlined,
                        label: 'Category',
                        value: capitalize(sub.category),
                      ),
                      InfoRow(
                        icon: Icons.paid_outlined,
                        label: 'Currency',
                        value: sub.currency,
                      ),
                      InfoRow(
                        icon: Icons.check_circle_outline,
                        label: 'Status',
                        trailing: const ActivePill(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
