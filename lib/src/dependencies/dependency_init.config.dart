// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../an_core_firebase.dart' as _i139;
import '../firebase/firebase_analytics_helper.dart' as _i853;
import '../firebase/notification_service.dart' as _i650;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i650.AppNotificationService>(
      () => _i650.AppNotificationService());
  gh.factory<_i853.FirebaseAnalyticsHelper>(
      () => _i853.FirebaseAnalyticsHelper());
  gh.lazySingleton<_i139.RemoteConfigService>(
      () => appModule.remoteConfigService);
  return getIt;
}

class _$AppModule extends _i291.AppModule {}
