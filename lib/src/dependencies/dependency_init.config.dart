// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_analytics/firebase_analytics.dart' as _i4;
import 'package:firebase_core/firebase_core.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../firebase/firebase_analytics_helper.dart' as _i5;
import '../firebase/notification_service.dart' as _i3;
import 'register_module.dart' as _i7;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.AppNotificationService>(() => _i3.AppNotificationService());
  gh.singleton<_i4.FirebaseAnalytics>(registerModule.firebaseMessaging());
  gh.factory<_i5.FirebaseAnalyticsHelper>(() => _i5.FirebaseAnalyticsHelper());
  gh.singletonAsync<_i6.FirebaseApp>(() => registerModule.firebase());
  return getIt;
}

class _$RegisterModule extends _i7.RegisterModule {}
