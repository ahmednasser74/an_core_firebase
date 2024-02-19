library firebase_services;

import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';

abstract class FirebaseServices {
  Future<void> initializeFirebase();
  Future<void> initializeCrashlytics();
  initializeDynamicLinks(StreamController<Uri> streamController);
  Future<void> initializeRemoteConfig();
  Future<void> initializeNotifications(GlobalKey<NavigatorState> navigatorKey);
  Future<void> unSubscribeFromTopic(String topic);
  Future<void> subscribeFromTopic(String topic);
}
