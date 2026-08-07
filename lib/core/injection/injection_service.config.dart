// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:subzero/core/app_routers/app_routers.dart' as _i532;
import 'package:subzero/core/pro/cubit/pro_cubit.dart' as _i706;
import 'package:subzero/core/pro/service/pro_services.dart' as _i686;
import 'package:subzero/core/services/firebase/auth_firebase_service.dart'
    as _i437;
import 'package:subzero/core/services/firebase/firebase_module.dart' as _i156;
import 'package:subzero/core/services/toast/toast_service.dart' as _i350;
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart'
    as _i958;
import 'package:subzero/feature/dashboard/model/subscription_model.dart'
    as _i286;
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i82;
import 'package:subzero/feature/notification/presentation/cubit/notification_cubit.dart'
    as _i253;
import 'package:subzero/feature/subscription_info/presentation/cubit/subscription_info_cubit.dart'
    as _i419;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i253.NotificationCubit>(() => _i253.NotificationCubit());
    gh.singleton<_i532.AppRouters>(() => _i532.AppRouters());
    gh.lazySingleton<_i686.ProService>(() => _i686.ProService());
    gh.lazySingleton<_i350.ToastService>(() => _i350.ToastService());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i706.ProCubit>(
        () => _i706.ProCubit(gh<_i686.ProService>()));
    gh.lazySingleton<_i437.AuthFirebaseService>(() => _i437.AuthFirebaseService(
          gh<_i59.FirebaseAuth>(),
          gh<_i974.FirebaseFirestore>(),
        ));
    gh.factory<_i156.SubscriptionFirebaseService>(
        () => _i156.SubscriptionFirebaseService(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.factoryParam<_i419.SubscriptionInfoCubit, _i286.SubscriptionModel,
        dynamic>((
      sub,
      _,
    ) =>
        _i419.SubscriptionInfoCubit(sub));
    gh.factory<_i958.AddSubCubit>(() => _i958.AddSubCubit(
          gh<_i532.AppRouters>(),
          gh<_i350.ToastService>(),
          gh<_i156.SubscriptionFirebaseService>(),
          gh<_i706.ProCubit>(),
        ));
    gh.factory<_i82.DashboardCubit>(
        () => _i82.DashboardCubit(gh<_i156.SubscriptionFirebaseService>()));
    return this;
  }
}

class _$FirebaseModule extends _i156.FirebaseModule {}
