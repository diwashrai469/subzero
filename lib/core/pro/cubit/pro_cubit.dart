import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/core/pro/service/pro_services.dart';

import 'pro_state.dart';

@lazySingleton
class ProCubit extends Cubit<ProState> {
  ProCubit(this._proService) : super(const ProState());

  final ProService _proService;

  Future<void> loadProStatus() async {
    final isPro = await _proService.isPro();

    debugPrint('===========================');
    debugPrint('RevenueCat Pro Status: $isPro');
    debugPrint('===========================');

    emit(state.copyWith(isPro: isPro));
  }

  void setPro(bool value) {
    emit(state.copyWith(isPro: value));
  }

  Future<bool> purchaseLifetime() async {
    final isPro = await _proService.purchaseLifetime();

    if (isPro) {
      emit(state.copyWith(isPro: true));
    }

    return isPro;
  }
}
