

abstract class NotificationServiceInterface {
  Future<dynamic> getNotificationList(int offset);
  Future<dynamic> sendReadStatus(int notificationId);
}