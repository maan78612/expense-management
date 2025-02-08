import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/notifications/data/data_source/remote/notifications_data_source.dart';
import 'package:expense_managment/src/features/notifications/domain/models/notification_model.dart';
import 'package:expense_managment/src/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationDataSource _notificationDataSource =
      NotificationDataSource();

  @override
  Future<List<NotificationModel>> fetchNotifications(
      UserModel currentUser) async {
    try {
      return await _notificationDataSource.fetchNotification(currentUser);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> addNotification(
      {required NotificationModel notification}) async {
    try {
      await _notificationDataSource.addNotification(notification);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification({required String notificationId}) async {
    try {
      await _notificationDataSource.deleteNotification(notificationId);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchFCM({required List<String> userIds}) async {
    try {
      return await _notificationDataSource.fetchFcmArray(userIds);
    } catch (_) {
      rethrow;
    }
  }
}
