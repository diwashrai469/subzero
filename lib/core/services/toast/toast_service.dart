import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:oktoast/oktoast.dart';
import '../../../common/widgets/k_toast.dart';

enum ToastVariant { success, error, warning, info }

@lazySingleton
class ToastService {
  ToastFuture s(String message, {Duration? duration}) =>
      show(message, variant: ToastVariant.success, duration: duration);

  ToastFuture? e(String message, {Duration? duration}) =>
      show(message, variant: ToastVariant.error, duration: duration);

  ToastFuture w(String message, {Duration? duration}) =>
      show(message, variant: ToastVariant.warning, duration: duration);

  ToastFuture i(String message, {Duration? duration}) =>
      show(message, variant: ToastVariant.info, duration: duration);

  ToastFuture show(
    String message, {
    required ToastVariant variant,
    Duration? duration,
  }) {
    return showToastWidget(
      KToast(message: message, variant: variant),
      position: ToastPosition.bottom,
      animationCurve: Curves.easeIn,
      dismissOtherToast: true,
      duration: duration,
    );
  }
}
