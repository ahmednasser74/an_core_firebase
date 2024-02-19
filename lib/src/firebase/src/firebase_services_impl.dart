import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:routers/routers.dart';

import 'firebase_services.dart';

class FirebaseServicesImpl implements FirebaseServices {
  @override
  Future<void> initializeCrashlytics() async {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  }

  @override
  initializeDynamicLinks(streamController) async {
    // FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
    //   debugPrint('dynamic link: ${dynamicLinkData.link.query}');
    //   streamController.add(dynamicLinkData.link);
    // }).onError((error) {
    //   debugPrint('onLink error');
    //   debugPrint(error.message);
    // });
  }

  @override
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Future<void> initializeRemoteConfig() async {
    //TODO: will be configured based on usage
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    // final defaults = <String, dynamic>{'v${packageInfo.buildNumber}': 0};
    // await remoteConfig.setDefaults(defaults);
    //
    // try {
    //   remoteConfig.setConfigSettings(RemoteConfigSettings(
    //       fetchTimeout: Duration(milliseconds: 21600000),
    //       minimumFetchInterval: Duration(milliseconds: 30000)));
    //   await remoteConfig.fetchAndActivate();
    //   String API_KEY = remoteConfig.getValue('API_KEY').asString();
    //   // ConstantsData().API_KEY = API_KEY;
    // } catch (e) {
    //   print(e);
    // }
    // return remoteConfig.getInt('v${packageInfo.buildNumber}');
  }

  GlobalKey<NavigatorState>? navigatorKey;

  @override
  Future<void> initializeNotifications(GlobalKey<NavigatorState> navigatorKey) async {
    this.navigatorKey = navigatorKey;
    await _requestPermission();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCMToken: $fcmToken');
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    _listenToForegroundMessages();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      debugPrint('FCM Token: $fcmToken');
    }).onError((err) {
      // Error getting token.
    });
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }
      localNotification(
        message.notification,
      );
    });
  }

  Future<void> localNotification(
    RemoteNotification? notification,
  ) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.max,
    );
    var initializationSettingsAndroid = const AndroidInitializationSettings('mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
          1,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
            ),
          ));
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    //TODO Navigate to Notifications Screen
    // navigatorKey?.currentState!.pushNamed(NotificationsScreens.notificationsScreen);
  }

  @override
  Future<void> unSubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  @override
  Future<void> subscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
/*
  Future<void> _fcmCall() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final NetworkUtil networkUtil;

    try {
      dynamic result =
      await networkUtil.postUrlEncoded(UrlsData.fcmTokenUrl, body: {
        "deviceId": "",
        "mobileDeviceId": fcmToken,
      });
      debugPrint(result.toString());
      return;
    } catch (error) {
      debugPrint(error.toString());
      // throw error;
    }
  }*/
}
