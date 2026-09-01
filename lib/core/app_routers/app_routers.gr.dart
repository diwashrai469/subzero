// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:subzero/feature/add_subscription/presentation/view/add_subscription_view.dart'
    as _i1;
import 'package:subzero/feature/dashboard/model/subscription_model.dart' as _i9;
import 'package:subzero/feature/dashboard/presentation/view/dashboard_view.dart'
    as _i3;
import 'package:subzero/feature/delete_account/presentation/delete_account_view.dart'
    as _i4;
import 'package:subzero/feature/login/presentation/view/auth_gate_view.dart'
    as _i2;
import 'package:subzero/feature/notification/presentation/view/notification_view.dart'
    as _i5;
import 'package:subzero/feature/subscription_info/presentation/view/subscription_info_view.dart'
    as _i6;

abstract class $AppRouters extends _i7.RootStackRouter {
  $AppRouters({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    AddSubscriptionView.name: (routeData) {
      final args = routeData.argsAs<AddSubscriptionViewArgs>(
          orElse: () => const AddSubscriptionViewArgs());
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddSubscriptionView(
          key: args.key,
          existingSub: args.existingSub,
          subCount: args.subCount,
        ),
      );
    },
    AuthGateView.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AuthGateView(),
      );
    },
    DashboardView.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.DashboardView(),
      );
    },
    DeleteAccountView.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.DeleteAccountView(),
      );
    },
    NotificationView.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.NotificationView(),
      );
    },
    SubscriptionInfoView.name: (routeData) {
      final args = routeData.argsAs<SubscriptionInfoViewArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.SubscriptionInfoView(
          key: args.key,
          sub: args.sub,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddSubscriptionView]
class AddSubscriptionView extends _i7.PageRouteInfo<AddSubscriptionViewArgs> {
  AddSubscriptionView({
    _i8.Key? key,
    _i9.SubscriptionModel? existingSub,
    int? subCount,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          AddSubscriptionView.name,
          args: AddSubscriptionViewArgs(
            key: key,
            existingSub: existingSub,
            subCount: subCount,
          ),
          initialChildren: children,
        );

  static const String name = 'AddSubscriptionView';

  static const _i7.PageInfo<AddSubscriptionViewArgs> page =
      _i7.PageInfo<AddSubscriptionViewArgs>(name);
}

class AddSubscriptionViewArgs {
  const AddSubscriptionViewArgs({
    this.key,
    this.existingSub,
    this.subCount,
  });

  final _i8.Key? key;

  final _i9.SubscriptionModel? existingSub;

  final int? subCount;

  @override
  String toString() {
    return 'AddSubscriptionViewArgs{key: $key, existingSub: $existingSub, subCount: $subCount}';
  }
}

/// generated route for
/// [_i2.AuthGateView]
class AuthGateView extends _i7.PageRouteInfo<void> {
  const AuthGateView({List<_i7.PageRouteInfo>? children})
      : super(
          AuthGateView.name,
          initialChildren: children,
        );

  static const String name = 'AuthGateView';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DashboardView]
class DashboardView extends _i7.PageRouteInfo<void> {
  const DashboardView({List<_i7.PageRouteInfo>? children})
      : super(
          DashboardView.name,
          initialChildren: children,
        );

  static const String name = 'DashboardView';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.DeleteAccountView]
class DeleteAccountView extends _i7.PageRouteInfo<void> {
  const DeleteAccountView({List<_i7.PageRouteInfo>? children})
      : super(
          DeleteAccountView.name,
          initialChildren: children,
        );

  static const String name = 'DeleteAccountView';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NotificationView]
class NotificationView extends _i7.PageRouteInfo<void> {
  const NotificationView({List<_i7.PageRouteInfo>? children})
      : super(
          NotificationView.name,
          initialChildren: children,
        );

  static const String name = 'NotificationView';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SubscriptionInfoView]
class SubscriptionInfoView extends _i7.PageRouteInfo<SubscriptionInfoViewArgs> {
  SubscriptionInfoView({
    _i8.Key? key,
    required _i9.SubscriptionModel sub,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          SubscriptionInfoView.name,
          args: SubscriptionInfoViewArgs(
            key: key,
            sub: sub,
          ),
          initialChildren: children,
        );

  static const String name = 'SubscriptionInfoView';

  static const _i7.PageInfo<SubscriptionInfoViewArgs> page =
      _i7.PageInfo<SubscriptionInfoViewArgs>(name);
}

class SubscriptionInfoViewArgs {
  const SubscriptionInfoViewArgs({
    this.key,
    required this.sub,
  });

  final _i8.Key? key;

  final _i9.SubscriptionModel sub;

  @override
  String toString() {
    return 'SubscriptionInfoViewArgs{key: $key, sub: $sub}';
  }
}
