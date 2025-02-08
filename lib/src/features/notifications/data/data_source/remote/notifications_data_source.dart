import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_managment/src/core/constants/firebase.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';

import 'package:expense_managment/src/features/notifications/domain/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationDataSource {
  Future<List<NotificationModel>> fetchNotification(
      UserModel currentUser) async {
    try {
      Query notificationsQuery = FBCollections.notifications;

      notificationsQuery = notificationsQuery.where('sendTo',
          arrayContains: currentUser.email.toString());

      final notificationsSnapshot = await notificationsQuery.get();

      final List<NotificationModel> notifications = notificationsSnapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();

      return notifications;
    } catch (e) {
      debugPrint("Error in fetchNotification: $e");
      rethrow;
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    DocumentReference notificationRef =
        FBCollections.notifications.doc(notification.id.toString());
    try {
      await notificationRef.set(notification.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    DocumentReference notificationRef =
        FBCollections.notifications.doc(notificationId);
    try {
      await notificationRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchFcmArray(List<String> userIDs) async {
    try {
      // Initialize an empty list to store FCM tokens
      List<String> fcmTokens = [];

      // Iterate through each user ID in the provided list
      for (String userId in userIDs) {
        // Reference to the user's document
        DocumentReference userRef = FBCollections.users.doc(userId);

        // Fetch the user's document
        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          // Assuming the FCM token is stored under the 'fcmToken' field in the user's document
          String? fcmToken = userSnapshot['fcm'];

          // Add the FCM token to the list if it's not null and not empty
          if (fcmToken != null && fcmToken.isNotEmpty) {
            fcmTokens.add(fcmToken);
          }
        }
      }

      // Return the list of FCM tokens
      return fcmTokens;
    } catch (e) {
      debugPrint('Error fetching FCM tokens: $e');
      rethrow;
    }
  }
}
