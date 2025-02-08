import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';

import 'package:expense_managment/src/features/notifications/domain/models/notification_model.dart';

abstract class NotificationsRepository {
  Future<List<NotificationModel>> fetchNotifications(UserModel currentUser);

  Future<void> addNotification({required NotificationModel notification});
  Future<void> deleteNotification({required String notificationId});
  Future<List<String>> fetchFCM({required List<String> userIds}) ;
}
