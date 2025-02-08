import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late NotificationDetails notificationDetails;

/*--------------------------- METHODS-----------------------------------*/

  Future<void> onInit() async {
    await _setNotificationInitialSetting();
    _setNotificationDetails();
  }

  /*========= initialization of Flutter Local Notifications=========*/
  Future<void> _setNotificationInitialSetting() async {
    /// set this icon in AndroidManifest as well
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /*========= Set Flutter local notification details=========*/
  void _setNotificationDetails() {
    /// Set channel for Android also set channel id in AndroidManifest as well
    /// i.e [high_importance_channel]

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        "high_importance_channel", "High Importance Notifications",
        importance: Importance.max, showBadge: true);

    notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /*========= Show  Flutter Local Notifications=========*/
  Future<void> showNotification(int id, String? title, String? body) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      "$title",
      body,
      notificationDetails,
    );
  }
}
