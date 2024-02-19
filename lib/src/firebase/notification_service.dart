import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
// todo
// 1- add both lines in application scope of mainfest file
// <meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="default_notification_channel"/>
// <meta-data android:name="firebase_messaging_auto_init_enabled" android:value="false"/>

@Injectable()
class AppNotificationService {
  static final AppNotificationService _instance = AppNotificationService._();

  AppNotificationService();
  AppNotificationService._();

  static AppNotificationService get instance => _instance;
  late FirebaseMessaging messaging;

  Future<void> init() async {
    print('object');
    messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    _initAndFireLocalNotification();

    await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    _listenOnBackgroundMessage((onBackgroundMessagesCallback) {});
    _listenOnMessageAndFireLocalNotification();
  }

  void onNotificationListener({
    required Function(RemoteMessage message) onBackgroundMessagesCallback,
    required Function(NotificationResponse details) onTapLocalNotification,
    required void Function(NotificationResponse)? onReceiveBgLocalNotification,
    String? androidAppIcon,
  }) {
    _setupOnMessageOpenedApp(onBackgroundMessagesCallback: onBackgroundMessagesCallback);
    _listenOnBackgroundMessage(onBackgroundMessagesCallback);
    _initAndFireLocalNotification(
      onTapLocalNotification: onTapLocalNotification,
      androidAppIcon: androidAppIcon,
    );
  }

  void _initAndFireLocalNotification({
    Function(NotificationResponse details)? onTapLocalNotification,
    void Function(NotificationResponse)? onReceiveBgLocalNotification,
    String? androidAppIcon,
  }) async {
    await FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true),
      ),

      /// [onDidReceiveBackgroundNotificationResponse] callback is invoked on a background isolate. Functions passed to the
      onDidReceiveBackgroundNotificationResponse: onReceiveBgLocalNotification,

      /// The [onDidReceiveNotificationResponse] callback is fired when the user
      /// selects a notification or notification action that should show the
      /// application/user interface.
      ///lama bados 3ala el notification mn bara w app in bg mesh terminate
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _log('onDidReceiveNotificationResponse:', '$details');
        if (onTapLocalNotification != null) onTapLocalNotification(details);
      },
    );
  }

  // static Future<void> localNotificationMyBackgroundMessageHandler(NotificationResponse response) async {
  //   debugPrint('onDidReceiveBackgroundNotificationResponse: $response');
  //   // if (onTapLocalNotification != null) onTapLocalNotification(response);
  // }

  Future<void> _showLocalNotification({RemoteMessage? message}) async {
    _log('Showing local notification', message?.notification?.title ?? "");
    await FlutterLocalNotificationsPlugin().show(
      Random().nextInt(100),
      message?.notification?.title ?? '',
      message?.notification?.body ?? '',
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'default_notification_channel',
          'Basic Notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ESU Notification',
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
          badgeNumber: Random().nextInt(100),
        ),
      ),
      // payload: event.data['route'],
    );
  }

  void _listenOnMessageAndFireLocalNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message: message);
    });
  }

  /// for background and terminated received messages
  void _listenOnBackgroundMessage(Function(RemoteMessage message) onBackgroundMessagesCallback) {
    FirebaseMessaging.onBackgroundMessage(
      (message) async {
        _log("FirebaseMessaging.onBackgroundMessage", message);
        onBackgroundMessagesCallback(message);
      },
    );
  }

  /// If the application has been opened from a terminated state via a [RemoteMessage]
  Future<void> _setupOnMessageOpenedApp({
    required Function(RemoteMessage message) onBackgroundMessagesCallback,
  }) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) onBackgroundMessagesCallback(initialMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _log("FirebaseMessaging.onMessageOpenedApp", message);
      onBackgroundMessagesCallback(message);
      // await _showLocalNotification(message: message);
    });
  }

  Future<void> removeToken() async => await messaging.deleteToken();

  Future<String> get getFcmToken async => Platform.isIOS ? await messaging.getAPNSToken() ?? '' : await messaging.getToken() ?? '';

  _log(String title, Object message) => debugPrint('>>>>>>>>>>>>> [ AppNotificationHelper ] [ $title ] [ $message ]');
}
