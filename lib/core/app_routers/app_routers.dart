import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import "app_routers.gr.dart";

@singleton
@AutoRouterConfig()
class AppRouters extends $AppRouters {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AddSubscriptionView.page),
    AutoRoute(page: DashboardView.page),
    AutoRoute(page: SubscriptionInfoView.page),
    // AutoRoute(page: LoginView.page),
    AutoRoute(page: AuthGateView.page, initial: true),
  ];
}
