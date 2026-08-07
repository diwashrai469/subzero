// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:subzero/feature/add_subscription/presentation/view/add_subscription_view.dart'
    as _i1;
import 'package:subzero/feature/dashboard/model/subscription_model.dart' as _i8;
import 'package:subzero/feature/dashboard/presentation/view/dashboard_view.dart'
    as _i3;
import 'package:subzero/feature/login/presentation/view/auth_gate_view.dart'
    as _i2;
import 'package:subzero/feature/notification/presentation/view/notification_view.dart'
    as _i4;
import 'package:subzero/feature/subscription_info/presentation/view/subscription_info_view.dart'
    as _i5;

abstract class $AppRouters extends _i6.RootStackRouter {
  $AppRouters({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    AddSubscriptionView.name: (routeData) {
      final args = routeData.argsAs<AddSubscriptionViewArgs>(
          orElse: () => const AddSubscriptionViewArgs());
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddSubscriptionView(
          key: args.key,
          existingSub: args.existingSub,
          subCount: args.subCount,
        ),
      );
    },
    AuthGateView.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AuthGateView(),
      );
    },
    DashboardView.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.DashboardView(),
      );
    },
    NotificationView.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.NotificationView(),
      );
    },
    SubscriptionInfoView.name: (routeData) {
      final args = routeData.argsAs<SubscriptionInfoViewArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.SubscriptionInfoView(
          key: args.key,
          sub: args.sub,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddSubscriptionView]
class AddSubscriptionView extends _i6.PageRouteInfo<AddSubscriptionViewArgs> {
  AddSubscriptionView({
    _i7.Key? key,
    _i8.SubscriptionModel? existingSub,
    int? subCount,
    List<_i6.PageRouteInfo>? children,
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

  static const _i6.PageInfo<AddSubscriptionViewArgs> page =
      _i6.PageInfo<AddSubscriptionViewArgs>(name);
}

class AddSubscriptionViewArgs {
  const AddSubscriptionViewArgs({
    this.key,
    this.existingSub,
    this.subCount,
  });

  final _i7.Key? key;

  final _i8.SubscriptionModel? existingSub;

  final int? subCount;

  @override
  String toString() {
    return 'AddSubscriptionViewArgs{key: $key, existingSub: $existingSub, subCount: $subCount}';
  }
}

/// generated route for
/// [_i2.AuthGateView]
class AuthGateView extends _i6.PageRouteInfo<void> {
  const AuthGateView({List<_i6.PageRouteInfo>? children})
      : super(
          AuthGateView.name,
          initialChildren: children,
        );

  static const String name = 'AuthGateView';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DashboardView]
class DashboardView extends _i6.PageRouteInfo<void> {
  const DashboardView({List<_i6.PageRouteInfo>? children})
      : super(
          DashboardView.name,
          initialChildren: children,
        );

  static const String name = 'DashboardView';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.NotificationView]
class NotificationView extends _i6.PageRouteInfo<void> {
  const NotificationView({List<_i6.PageRouteInfo>? children})
      : super(
          NotificationView.name,
          initialChildren: children,
        );

  static const String name = 'NotificationView';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SubscriptionInfoView]
class SubscriptionInfoView extends _i6.PageRouteInfo<SubscriptionInfoViewArgs> {
  SubscriptionInfoView({
    _i7.Key? key,
    required _i8.SubscriptionModel sub,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          SubscriptionInfoView.name,
          args: SubscriptionInfoViewArgs(
            key: key,
            sub: sub,
          ),
          initialChildren: children,
        );

  static const String name = 'SubscriptionInfoView';

  static const _i6.PageInfo<SubscriptionInfoViewArgs> page =
      _i6.PageInfo<SubscriptionInfoViewArgs>(name);
}

class SubscriptionInfoViewArgs {
  const SubscriptionInfoViewArgs({
    this.key,
    required this.sub,
  });

  final _i7.Key? key;

  final _i8.SubscriptionModel sub;

  @override
  String toString() {
    return 'SubscriptionInfoViewArgs{key: $key, sub: $sub}';
  }
}
