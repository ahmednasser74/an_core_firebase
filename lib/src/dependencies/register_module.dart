import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';

@module
abstract class RegisterModule {
  @singleton
  FirebaseAnalytics firebaseMessaging() => FirebaseAnalytics.instance;

  @singleton
  Future<FirebaseApp> firebase() => Firebase.initializeApp();
}
