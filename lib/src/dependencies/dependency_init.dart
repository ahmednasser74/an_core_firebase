import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_init.config.dart';

final GetIt firebasePackageGetIt = GetIt.instance;

@InjectableInit(
  usesNullSafety: true,
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<GetIt> firebaseCorePackageConfigureDependencies() async {
  return $initGetIt(firebasePackageGetIt);
}
