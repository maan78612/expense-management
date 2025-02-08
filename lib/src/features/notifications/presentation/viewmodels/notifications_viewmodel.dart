
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:expense_managment/src/features/notifications/domain/models/notification_model.dart';
import 'package:expense_managment/src/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationsViewModel with ChangeNotifier {
  final NotificationsRepository _notificationsRepository =
      NotificationsRepositoryImpl();

  List<NotificationModel> notifications = [];
  Map<String, List<NotificationModel>> groupedNotifications = {
    'Today': [],
    'Yesterday': [],
    'Older': [],
  };
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> init(UserModel currentUser) async {
    try {
      setLoading(true);
      final notificationData =
          await _notificationsRepository.fetchNotifications(currentUser);
      notifications.clear();
      notifications = [...notificationData];
      groupNotifications(notifications);
    } catch (error) {
      debugPrint("notifications error =${error.toString()}");
    } finally {
      setLoading(false);
    }

    notifyListeners();
  }

  void groupNotifications(List<NotificationModel> notifications) {
    final now = DateTime.now();

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (var notification in notifications) {
      final notificationDate = notification.createdAt;

      if (notificationDate.year == now.year &&
          notificationDate.month == now.month &&
          notificationDate.day == now.day) {
        groupedNotifications['Today']?.add(notification);
      } else if (notificationDate.year == now.year &&
          notificationDate.month == now.month &&
          notificationDate.day == now.day - 1) {
        groupedNotifications['Yesterday']?.add(notification);
      } else {
        groupedNotifications['Older']?.add(notification);
      }
    }
  }

  Future<void> deleteNotification(
      String group, NotificationModel notification) async {
    try {
      setLoading(true);

      notifications.removeWhere((data) => data.id == notification.id);

      removeFromGroupedNotifications(group, notification);
      await _notificationsRepository.deleteNotification(
          notificationId: notification.id.toString());
    } catch (error) {
      debugPrint("deleteNotification error = ${error.toString()}");
    } finally {
      setLoading(false);
    }
  }

  void removeFromGroupedNotifications(
      String group, NotificationModel notification) {
    groupedNotifications[group]
        ?.removeWhere((data) => data.id == notification.id);
  }
}
