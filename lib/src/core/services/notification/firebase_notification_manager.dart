import 'package:expense_managment/src/core/services/notification/flutter_local_notification_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FBNotificationManager {
  final FlutterLocalNotificationManager _flutterLocalNotificationManager =
      FlutterLocalNotificationManager();

  /// Singleton pattern to ensure a single instance
  static final FBNotificationManager _instance =
      FBNotificationManager._internal();

  factory FBNotificationManager() => _instance;

  FBNotificationManager._internal();

  /// Initialize notifications
  Future<void> init() async {
    await _requestPermissionAndSetup();
  }

  Future<void> _requestPermissionAndSetup() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      await _flutterLocalNotificationManager.onInit();
      _listenToForegroundNotifications();
      await _handleOnNotificationsOpened();
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _handleOnNotificationsOpened() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      debugPrint("Message on [APP TERMINATED] ${message.notification?.body}");
    }
  }

  void _listenToForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _flutterLocalNotificationManager.showNotification(message.hashCode,
          message.notification?.title, message.notification?.body);
      debugPrint(
          "Message on [APP Background or Foreground] ${message.notification?.title}");
    });
  }
}
