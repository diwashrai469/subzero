import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/currency_data.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/common/widgets/k_appbar.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_sub_button.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_sub_category_selector.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_sub_cycle_selector.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_sub_date_field.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_sub_textfield.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/currency_picker_sheet.dart';
import 'package:subzero/feature/dashboard/model/subscription_model.dart';

@RoutePage()
class AddSubscriptionView extends StatefulWidget {
  final SubscriptionModel? existingSub;

  const AddSubscriptionView({super.key, this.existingSub});

  @override
  State<AddSubscriptionView> createState() => _AddSubscriptionViewState();
}

class _AddSubscriptionViewState extends State<AddSubscriptionView> {
  late final AddSubCubit cubit;
  late final TextEditingController nameController;
  late final TextEditingController amountController;

  bool get isEditing => widget.existingSub != null;

  @override
  void initState() {
    super.initState();

    cubit = locator<AddSubCubit>();
    final sub = widget.existingSub;

    nameController = TextEditingController(text: sub?.name ?? '');
    amountController = TextEditingController(
      text: sub == null ? '' : sub.amount.toString(),
    );

    if (sub != null) {
      _fillExistingData(sub);
    }
  }

  void _fillExistingData(SubscriptionModel sub) {
    cubit
      ..setName(sub.name)
      ..setAmount(sub.amount.toString())
      ..setCurrency(sub.currencyCode)
      ..setCycle(sub.billingCycle)
      ..setCategory(sub.category)
      ..setDate(sub.firstBillDate);
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    cubit.close();
    super.dispose();
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CurrencyPickerSheet(
        selected: cubit.state.currency,
        onSelected: cubit.setCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<AddSubCubit, AddSubState>(
        builder: (_, state) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: kAppbar(
              text: isEditing ? 'Edit Subscription' : 'Add Subscription',
              context: context,
            ),
            body: SafeArea(
              bottom: false,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                children: [
                  sHeightSpan,
                  _sectionCard(
                    title: 'Subscription details',
                    subtitle: 'Enter the service name and amount.',
                    children: [
                      _fieldLabel('Name'),
                      addSubTextField(
                        controller: nameController,
                        hint: 'Netflix, Spotify, iCloud',
                        onChanged: cubit.setName,
                        prefixIcon: Icons.subscriptions_rounded,
                        textInputAction: TextInputAction.next,
                        compact: true,
                      ),

                      mHeightSpan,

                      _fieldLabel('Amount'),
                      _amountRow(state),
                    ],
                  ),

                  mHeightSpan,

                  _sectionCard(
                    title: 'Billing schedule',
                    subtitle: 'Choose the first bill date and repeat cycle.',
                    children: [
                      _fieldLabel('First billing date'),
                      AddSubDateField(
                        initialDate: state.firstBillDate,
                        onDateSelected: cubit.setDate,
                      ),

                      mHeightSpan,

                      _fieldLabel('Billing cycle'),
                      addSubCycleSelector(state: state, cubit: cubit),
                    ],
                  ),

                  mHeightSpan,

                  _sectionCard(
                    title: 'Category',
                    subtitle: 'Choose how this subscription should be grouped.',
                    children: [
                      addSubCategorySelector(
                        state: state,
                        context: context,
                        cubit: cubit,
                      ),
                    ],
                  ),

                  lHeightSpan,
                  saveButton(
                    state: state,
                    context: context,
                    isEditing: isEditing,
                    cubit: cubit,
                    existingId: widget.existingSub?.id,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KText(text: title, fontSize: 17.sp, fontWeight: FontWeight.w600),
          xxsHeightSpan,
          KText(
            text: subtitle,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),

          mHeightSpan,
          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: KText(text: text, fontSize: 13.sp, fontWeight: FontWeight.w600),
    );
  }

  Widget _amountRow(AddSubState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: addSubTextField(
            controller: amountController,
            hint: '0.00',
            onChanged: cubit.setAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.payments_rounded,
            compact: true,
          ),
        ),
        sWidthSpan,
        Expanded(flex: 4, child: _currencyButton(state)),
      ],
    );
  }

  Widget _currencyButton(AddSubState state) {
    final flag = currencyDetails[state.currency]?['flag'] ?? '🌐';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showCurrencyPicker,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KText(text: flag, fontSize: 15.sp),
              sWidthSpan,
              Flexible(
                child: KText(
                  text: state.currency,
                  textAlign: TextAlign.center,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              xsWidthSpan,
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.sp,
                color: textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
