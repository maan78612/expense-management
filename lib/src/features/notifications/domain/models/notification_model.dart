import 'package:expense_managment/src/core/enums/notification_type.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final NotificationType type;
  final List<String> sendTo;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.sendTo,
  });

  // Factory method to create a NotificationModel from JSON
  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['timestamp'] as String),
      type: _notificationTypeFromString(json['type'] as String),
      sendTo: json['sendTo'] != null
          ? List<String>.from(json['sendTo'].map((x) => x))
          : [],
    );
  }

  // Method to convert a NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': createdAt.toIso8601String(),
      'type': _notificationTypeToString(type),
      'sendTo': List<String>.from(sendTo.map((x) => x))
    };
  }

  // Helper method to convert string to NotificationType
  static NotificationType _notificationTypeFromString(String type) {
    switch (type) {
      case 'success':
        return NotificationType.success;
      case 'failed':
        return NotificationType.failed;
      case 'warning':
        return NotificationType.warning;
      default:
        throw ArgumentError('Invalid notification type');
    }
  }

  // Helper method to convert NotificationType to string
  static String _notificationTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return 'success';
      case NotificationType.failed:
        return 'failed';
      case NotificationType.warning:
        return 'warning';
    }
  }
}
