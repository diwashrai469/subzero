import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:subzero/common/constant/currency_data.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/feature/add_subscription/presentation/constant/add_sub_constants.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_sub_date_field.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/category_picker.dart';
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

  static const Color bgColor = Color(0xFFF6F7F9);
  static const Color cardColor = Colors.white;
  static const Color inputColor = Color(0xFFF9FAFB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

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
      ..setCurrency(sub.currency)
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

  Future<void> _openCategoryPicker(AddSubState state) async {
    final selectedCategory = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CategoryPicker(selectedCategory: state.category),
      ),
    );

    if (selectedCategory != null && mounted) {
      cubit.setCategory(selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<AddSubCubit, AddSubState>(
        builder: (_, state) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: _appBar(),

            body: SafeArea(
              bottom: false,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                children: [
                  _heroCard(state),

                  SizedBox(height: 18.h),

                  _sectionCard(
                    title: 'Subscription details',
                    subtitle: 'Enter the service name and amount.',
                    children: [
                      _fieldLabel('Name'),
                      _textField(
                        controller: nameController,
                        hint: 'Netflix, Spotify, iCloud',
                        onChanged: cubit.setName,
                        prefixIcon: Icons.subscriptions_rounded,
                        textInputAction: TextInputAction.next,
                        compact: true,
                      ),

                      SizedBox(height: 14.h),

                      _fieldLabel('Amount'),
                      _amountRow(state),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  _sectionCard(
                    title: 'Billing schedule',
                    subtitle: 'Choose the first bill date and repeat cycle.',
                    children: [
                      _fieldLabel('First billing date'),
                      AddSubDateField(
                        initialDate: state.firstBillDate,
                        onDateSelected: cubit.setDate,
                      ),

                      SizedBox(height: 14.h),

                      _fieldLabel('Billing cycle'),
                      _cycleSelector(state),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  _sectionCard(
                    title: 'Category',
                    subtitle: 'Choose how this subscription should be grouped.',
                    children: [_categorySelector(state)],
                  ),

                  lHeightSpan,
                  _saveButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 58.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: _roundIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.router.maybePop(),
        ),
      ),
      title: Text(
        isEditing ? 'Edit Subscription' : 'Add Subscription',
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
      ),
    );
  }

  Widget _heroCard(AddSubState state) {
    final selectedCategory = categoriesList.firstWhere(
      (cat) => cat.label == state.category,
      orElse: () => categoriesList.first,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF111827),
            selectedCategory.iconColor.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: selectedCategory.iconColor.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28.w,
            top: -32.h,
            child: _decorCircle(96.r, Colors.white.withValues(alpha: 0.08)),
          ),
          Positioned(
            right: 22.w,
            bottom: -44.h,
            child: _decorCircle(72.r, Colors.white.withValues(alpha: 0.05)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: Icon(
                  isEditing ? Icons.edit_note_rounded : Icons.add_card_rounded,
                  color: Colors.white,
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing
                          ? 'Update your subscription'
                          : 'Track a new subscription',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18.sp,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      isEditing
                          ? 'Review your billing details and save the latest changes.'
                          : 'Add the details once and Subzero will help you stay ahead of every bill.',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.76),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
          Text(
            title,
            softWrap: true,
            style: TextStyle(
              fontSize: 17.sp,
              height: 1.2,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            subtitle,
            softWrap: true,
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        softWrap: true,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _inputBox({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    IconData? prefixIcon,
    bool compact = false,
  }) {
    return _inputBox(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: compact ? 9.h : 10.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            Container(
              width: compact ? 28.r : 30.r,
              height: compact ? 28.r : 30.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                prefixIcon,
                size: compact ? 15.sp : 16.sp,
                color: textSecondary,
              ),
            ),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              showCursor: true,
              enableInteractiveSelection: true,
              onChanged: (value) {
                onChanged(value);
                setState(() {});
              },
              style: TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
              decoration: _inputDecoration(hint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(AddSubState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: _textField(
            controller: amountController,
            hint: '0.00',
            onChanged: cubit.setAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.payments_rounded,
            compact: true,
          ),
        ),
        SizedBox(width: 10.w),
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
              Text(flag, style: TextStyle(fontSize: 15.sp)),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  state.currency,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
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

  Widget _cycleSelector(AddSubState state) {
    return Container(
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
        children: cycles.map((cycle) {
          final selected = cycle == state.billingCycle;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => cubit.setCycle(cycle),
              borderRadius: BorderRadius.circular(100.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: selected ? textPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: selected ? textPrimary : borderColor,
                  ),
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
                child: Text(
                  cycle,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _categorySelector(AddSubState state) {
    final selectedCategory = categoriesList.firstWhere(
      (cat) => cat.label == state.category,
      orElse: () => categoriesList.first,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openCategoryPicker(state),
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: selectedCategory.iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: selectedCategory.iconColor.withValues(alpha: 0.24),
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

              SizedBox(width: 13.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCategory.label,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Tap to choose another category',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13.sp,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => cubit.save(existingId: widget.existingSub?.id),
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          width: double.infinity,
          height: 45.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF111827), Color(0xFF030712)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isEditing
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 9.w),
              Flexible(
                child: Text(
                  isEditing ? 'Update Subscription' : 'Save Subscription',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
            child: Icon(icon, size: 20.sp, color: textPrimary),
          ),
        ),
      ),
    );
  }
}
