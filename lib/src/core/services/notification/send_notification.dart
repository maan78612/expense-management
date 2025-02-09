import 'dart:convert';
import 'package:expense_managment/src/core/enums/notification_type.dart';
import 'package:expense_managment/src/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:expense_managment/src/features/notifications/domain/models/notification_model.dart';
import 'package:expense_managment/src/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationManager {

  NotificationManager._privateConstructor();

  static final NotificationManager _instance =
      NotificationManager._privateConstructor();

  factory NotificationManager() => _instance;

  NotificationsRepository? _notificationsRepository;

  NotificationsRepository get _repo {
    _notificationsRepository ??= NotificationsRepositoryImpl();
    return _notificationsRepository!;
  }

  final String url =
      'https://fcm.googleapis.com/v1/projects/firebase_structure/messages:send';

  Future<void> send({
    required String title,
    required String message,
    required NotificationType type,
    required List<String> sendTo,
  }) async {
    NotificationModel newNotification = NotificationModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      message: message,
      createdAt: DateTime.now(),
      type: type,
      sendTo: sendTo,
    );

    try {
      // Save notification to repository
      await _repo.addNotification(notification: newNotification);

      // Fetch FCM tokens
      List<String> fcmList = await _repo.fetchFCM(userIds: sendTo);

      debugPrint("fcm list =${fcmList.length}");
      // Send push notifications in batch
      await _sendBatchPushNotifications(fcmList, title, message);
    } catch (error) {
      debugPrint("Error sending notification: ${error.toString()}");
    }
  }

  Future<void> _sendBatchPushNotifications(
    List<String> fcmTokens,
    String title,
    String message,
  ) async {
    if (fcmTokens.isEmpty) return;

    try {
      final client = await _getClient();

      for (String token in fcmTokens) {
        // Prepare the notification message for each token
        Map<String, dynamic> messagePayload = {
          'message': {
            'notification': {
              'title': title,
              'body': message,
            },
            'android': {
              'priority': 'high',
              'notification': {
                'sound': 'default',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'default',
                  'category': 'FLUTTER_NOTIFICATION_CLICK',
                },
              },
            },
            'token': token, // Use individual token
          }
        };

        var response = await client.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(messagePayload),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to send notification: ${response.body}');
        }

        if (kDebugMode) {
          print("Notification sent to $token: ${response.body}");
        }
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  Future<AutoRefreshingAuthClient> _getClient() async {
    final String jsonString = await rootBundle
        .loadString('assets/expense-managment-b15ec-firebase-adminsdk-fbsvc-7219be074c.json');

    final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccount, scopes);

    return client;
  }
}
