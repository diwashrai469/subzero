import 'package:bloc/bloc.dart';
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
  final AppRouters _router;
  final ToastService _toast;
  final SubscriptionFirebaseService _firebase;

  AddSubCubit(this._router, this._toast, this._firebase)
    : super(AddSubState(currency: getLocaleCurrency()));

  void setName(String v) => emit(state.copyWith(name: v));
  void setAmount(String v) => emit(state.copyWith(amount: v));
  void setCurrency(String v) => emit(state.copyWith(currency: v));
  void setCycle(String v) => emit(state.copyWith(billingCycle: v));
  void setCategory(String v) => emit(state.copyWith(category: v));
  void setDate(DateTime v) => emit(state.copyWith(firstBillDate: v));

  Future<void> save({String? existingId}) async {
    if (state.name.trim().isEmpty ||
        state.amount.trim().isEmpty ||
        state.firstBillDate == null) {
      _toast.i('Please fill name, amount and date');
      return;
    }

    final amount = double.tryParse(state.amount);
    if (amount == null) {
      _toast.i('Enter valid amount');
      return;
    }

    emit(state.copyWith(isLoading: true));

    final id = existingId ?? DateTime.now().millisecondsSinceEpoch.toString();

    final name = state.name.trim();
    final capitalizedName = name.isEmpty
        ? name
        : name[0].toUpperCase() + name.substring(1); // 👈

    await _firebase.saveSubscription(
      id: id,
      name: capitalizedName, // 👈
      amount: amount,
      currency: state.currency,
      billingCycle: state.billingCycle,
      category: state.category,
      firstBillDate: state.firstBillDate!,
      nextBillDate: calcNextBillDate(state.firstBillDate!, state.billingCycle),
      cancelUrl: null,
    );

    emit(state.copyWith(isLoading: false));
    _router.replaceAll([const DashboardView()]);
  }
}
