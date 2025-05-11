import 'package:an_core_firebase/an_core_firebase.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @lazySingleton
  RemoteConfigService get remoteConfigService => RemoteConfigService();
}
