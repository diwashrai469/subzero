import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:subzero/common/constant/currency_data.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/services/firebase/firebase_module.dart';
import 'package:subzero/core/services/toast/toast_service.dart';
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_state.dart';
import 'package:subzero/feature/add_subscription/presentation/widgets/add_susbcription_helper.dart';

@injectable
class AddSubCubit extends Cubit<AddSubState> {
  AddSubCubit(this._router, this._toast, this._firebase)
    : super(AddSubState(currency: getLocaleCurrency()));

  final AppRouters _router;
  final ToastService _toast;
  final SubscriptionFirebaseService _firebase;

  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  void setName(String value) {
    emit(state.copyWith(name: value));
  }

  void setAmount(String value) {
    emit(state.copyWith(amount: value));
  }

  void setCurrency(String value) {
    emit(state.copyWith(currency: value));
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

  Future<void> save({String? existingId}) async {
    final name = state.name.trim();
    final amountText = state.amount.trim();
    final firstBillDate = state.firstBillDate;

    if (name.isEmpty || amountText.isEmpty || firstBillDate == null) {
      _toast.i('Please fill name, amount and date');
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _toast.i('Enter a valid amount');
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final id = existingId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final subscriptionName = _capitalizeFirstLetter(name);
      final nextBillDate = calcNextBillDate(firstBillDate, state.billingCycle);

      await _firebase.saveSubscription(
        id: id,
        name: subscriptionName,
        amount: amount,
        currency: state.currency,
        billingCycle: state.billingCycle,
        category: state.category,
        firstBillDate: firstBillDate,
        nextBillDate: nextBillDate,
        cancelUrl: null,
      );

      _router.replaceAll([const DashboardView()]);
    } catch (error, stackTrace) {
      debugPrint('Failed to save subscription: $error');
      debugPrintStack(stackTrace: stackTrace);

      _toast.i('Failed to save subscription');
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
}
