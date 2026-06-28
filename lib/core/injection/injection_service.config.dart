// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:subzero/common/constant/english_calender_constants.dart' as _i4;
import 'package:subzero/common/constant/nepali_calender_constants.dart' as _i7;
import 'package:subzero/core/app_routers/app_routers.dart' as _i3;
import 'package:subzero/core/services/firebase/firebase_module.dart' as _i9;
import 'package:subzero/core/services/toast/toast_service.dart' as _i12;
import 'package:subzero/feature/add_subscription/presentation/cubit/add_sub_cubit.dart'
    as _i13;
import 'package:subzero/feature/dashboard/model/subscription_model.dart'
    as _i11;
import 'package:subzero/feature/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i15;
import 'package:subzero/feature/login/presentation/widgets/auth_firebase_service.dart'
    as _i14;
import 'package:subzero/feature/notification/presentation/cubit/notification_cubit.dart'
    as _i8;
import 'package:subzero/feature/subscription_info/presentation/cubit/subscription_info_cubit.dart'
    as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.singleton<_i3.AppRouters>(() => _i3.AppRouters());
    gh.lazySingleton<_i4.EnglishCalenderConstants>(
        () => _i4.EnglishCalenderConstants());
    gh.lazySingleton<_i5.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i6.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i7.NepaliCalenderConstants>(
        () => _i7.NepaliCalenderConstants());
    gh.factory<_i8.NotificationCubit>(() => _i8.NotificationCubit());
    gh.factory<_i9.SubscriptionFirebaseService>(
        () => _i9.SubscriptionFirebaseService(
              gh<_i6.FirebaseFirestore>(),
              gh<_i5.FirebaseAuth>(),
            ));
    gh.factoryParam<_i10.SubscriptionInfoCubit, _i11.SubscriptionModel,
        dynamic>((
      sub,
      _,
    ) =>
        _i10.SubscriptionInfoCubit(sub));
    gh.lazySingleton<_i12.ToastService>(() => _i12.ToastService());
    gh.factory<_i13.AddSubCubit>(() => _i13.AddSubCubit(
          gh<_i3.AppRouters>(),
          gh<_i12.ToastService>(),
          gh<_i9.SubscriptionFirebaseService>(),
        ));
    gh.lazySingleton<_i14.AuthFirebaseService>(() => _i14.AuthFirebaseService(
          gh<_i5.FirebaseAuth>(),
          gh<_i6.FirebaseFirestore>(),
        ));
    gh.factory<_i15.DashboardCubit>(
        () => _i15.DashboardCubit(gh<_i9.SubscriptionFirebaseService>()));
    return this;
  }
}

class _$FirebaseModule extends _i9.FirebaseModule {}
