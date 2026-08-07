import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:subzero/core/pro/constant/pro_constant.dart';

@lazySingleton
class ProService {
  Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);

    if (Platform.isIOS) {
      final configuration = PurchasesConfiguration(ProConstants.iosApiKey);
      await Purchases.configure(configuration);
    }
  }

  Future<bool> isPro() async {
    final customerInfo = await Purchases.getCustomerInfo();

    return customerInfo.entitlements.active.containsKey(
      ProConstants.entitlementId,
    );
  }

  Future<bool> purchaseLifetime() async {
    try {
      await Purchases.invalidateCustomerInfoCache();

      final currentCustomerInfo = await Purchases.getCustomerInfo();

      final alreadyPro = currentCustomerInfo.entitlements.active.containsKey(
        ProConstants.entitlementId,
      );

      if (alreadyPro) {
        throw StateError('This Apple account already owns SubZero Pro.');
      }

      final offerings = await Purchases.getOfferings();
      final lifetimePackage = offerings.current?.lifetime;

      if (lifetimePackage == null) {
        throw StateError('Lifetime package is not available.');
      }

      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(lifetimePackage),
      );

      return purchaseResult.customerInfo.entitlements.active.containsKey(
        ProConstants.entitlementId,
      );
    } on PlatformException catch (error) {
      final errorCode = PurchasesErrorHelper.getErrorCode(error);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return false;
      }

      rethrow;
    }
  }
}
