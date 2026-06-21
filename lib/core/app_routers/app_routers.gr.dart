// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:subzero/feature/add_subscription/presentation/view/add_subscription_view.dart'
    as _i1;
import 'package:subzero/feature/dashboard/model/subscription_model.dart' as _i7;
import 'package:subzero/feature/dashboard/presentation/view/dashboard_view.dart'
    as _i3;
import 'package:subzero/feature/login/presentation/view/login_view.dart' as _i2;
import 'package:subzero/feature/subscription_info/presentation/view/subscription_info_view.dart'
    as _i4;

abstract class $AppRouters extends _i5.RootStackRouter {
  $AppRouters({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    AddSubscriptionView.name: (routeData) {
      final args = routeData.argsAs<AddSubscriptionViewArgs>(
          orElse: () => const AddSubscriptionViewArgs());
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddSubscriptionView(
          key: args.key,
          existingSub: args.existingSub,
        ),
      );
    },
    AuthGateView.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AuthGateView(),
      );
    },
    DashboardView.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.DashboardView(),
      );
    },
    SubscriptionInfoView.name: (routeData) {
      final args = routeData.argsAs<SubscriptionInfoViewArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.SubscriptionInfoView(
          key: args.key,
          sub: args.sub,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddSubscriptionView]
class AddSubscriptionView extends _i5.PageRouteInfo<AddSubscriptionViewArgs> {
  AddSubscriptionView({
    _i6.Key? key,
    _i7.SubscriptionModel? existingSub,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          AddSubscriptionView.name,
          args: AddSubscriptionViewArgs(
            key: key,
            existingSub: existingSub,
          ),
          initialChildren: children,
        );

  static const String name = 'AddSubscriptionView';

  static const _i5.PageInfo<AddSubscriptionViewArgs> page =
      _i5.PageInfo<AddSubscriptionViewArgs>(name);
}

class AddSubscriptionViewArgs {
  const AddSubscriptionViewArgs({
    this.key,
    this.existingSub,
  });

  final _i6.Key? key;

  final _i7.SubscriptionModel? existingSub;

  @override
  String toString() {
    return 'AddSubscriptionViewArgs{key: $key, existingSub: $existingSub}';
  }
}

/// generated route for
/// [_i2.AuthGateView]
class AuthGateView extends _i5.PageRouteInfo<void> {
  const AuthGateView({List<_i5.PageRouteInfo>? children})
      : super(
          AuthGateView.name,
          initialChildren: children,
        );

  static const String name = 'AuthGateView';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DashboardView]
class DashboardView extends _i5.PageRouteInfo<void> {
  const DashboardView({List<_i5.PageRouteInfo>? children})
      : super(
          DashboardView.name,
          initialChildren: children,
        );

  static const String name = 'DashboardView';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SubscriptionInfoView]
class SubscriptionInfoView extends _i5.PageRouteInfo<SubscriptionInfoViewArgs> {
  SubscriptionInfoView({
    _i6.Key? key,
    required _i7.SubscriptionModel sub,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          SubscriptionInfoView.name,
          args: SubscriptionInfoViewArgs(
            key: key,
            sub: sub,
          ),
          initialChildren: children,
        );

  static const String name = 'SubscriptionInfoView';

  static const _i5.PageInfo<SubscriptionInfoViewArgs> page =
      _i5.PageInfo<SubscriptionInfoViewArgs>(name);
}

class SubscriptionInfoViewArgs {
  const SubscriptionInfoViewArgs({
    this.key,
    required this.sub,
  });

  final _i6.Key? key;

  final _i7.SubscriptionModel sub;

  @override
  String toString() {
    return 'SubscriptionInfoViewArgs{key: $key, sub: $sub}';
  }
}
