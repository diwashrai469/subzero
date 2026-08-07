import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/common/constant/currency_data.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/pro/constant/pro_constant.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/core/services/toast/toast_service.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_susbcription_helper.dart';

@injectable
class AddSubCubit extends Cubit<AddSubState> {
  AddSubCubit(this._router, this._toast, this._firebase, this._proCubit)
    : super(
        AddSubState(
          // State holds the ISO currency code, for example AUD.
          currency: getLocaleCurrency(),
        ),
      );

  final AppRouters _router;
  final ToastService _toast;
  final SubscriptionFirebaseService _firebase;
  final ProCubit _proCubit;

  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  void setName(String value) {
    emit(state.copyWith(name: value));
  }

  void setAmount(String value) {
    emit(state.copyWith(amount: value));
  }

  /// Receives a currency code such as AUD, USD or INR.
  void setCurrency(String currencyCode) {
    emit(state.copyWith(currency: currencyCode.trim().toUpperCase()));
  }

  void setCycle(String value) {
    emit(state.copyWith(billingCycle: value));
  }

  void setCategory(String value) {
    emit(state.copyWith(category: value));
  }

  void setDate(DateTime value) {
    emit(state.copyWith(firstBillDate: value));
  }

  void setReminderDays(List<int> reminderDays) {
    emit(state.copyWith(reminderDays: List<int>.from(reminderDays)));
  }

  void updateReminderDays(List<int> reminderDays) {
    emit(state.copyWith(reminderDays: List<int>.from(reminderDays)));
  }

  void toggleReminderDay(int day) {
    final updatedDays = List<int>.from(state.reminderDays);

    if (updatedDays.contains(day)) {
      updatedDays.remove(day);
    } else {
      updatedDays.add(day);
    }

    updatedDays.sort();

    if (updatedDays.isEmpty) {
      return;
    }

    emit(state.copyWith(reminderDays: updatedDays));
  }

  Future<void> save({String? existingId, int? subCount}) async {
    final isCreatingNewSubscription = existingId == null;
    final isPro = _proCubit.state.isPro;

    if (isCreatingNewSubscription &&
        !isPro &&
        subCount! >= ProConstants.freeSubscriptionLimit) {
      _toast.i(
        'Free users can add up to 10 recurring payments. Upgrade to Pro for unlimited access.',
      );
      return;
    }

    final name = state.name.trim();
    final amountText = state.amount.trim();
    final firstBillDate = state.firstBillDate;

    if (name.isEmpty || amountText.isEmpty || firstBillDate == null) {
      _toast.i('Please fill in all the required fields.');
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _toast.i('Enter a valid amount.');
      return;
    }

    if (state.currency.trim().isEmpty) {
      _toast.i('Please select a currency.');
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final id = existingId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final reminderDays = isPro ? state.reminderDays : const <int>[1];

      final subscriptionName = _capitalizeFirstLetter(name);

      final nextBillDate = calcNextBillDate(firstBillDate, state.billingCycle);

      final currencyCode = state.currency.trim().toUpperCase();

      final currencySymbol = getCurrencySymbol(currencyCode);

      await _firebase.saveSubscription(
        id: id,
        name: subscriptionName,
        amount: amount,
        currency: currencySymbol,
        currencyCode: currencyCode,
        billingCycle: state.billingCycle,
        category: state.category,
        firstBillDate: firstBillDate,
        nextBillDate: nextBillDate,
        totalTillDate: state.totalTillDate,
        reminderDays: reminderDays,
        cancelUrl: null,
      );

      _router.replaceAll([const DashboardView()]);
    } catch (error, stackTrace) {
      debugPrint('Failed to save subscription: $error');
      debugPrintStack(stackTrace: stackTrace);

      _toast.i('Failed to save subscription.');
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  String _capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Future<void> close() {
    isLoadingNotifier.dispose();
    return super.close();
  }
}
