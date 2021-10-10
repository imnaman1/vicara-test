import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> buttonNotification() async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_notification',
        title: 'Success!',
        body: 'Added the Values to WebSocket!',
        notificationLayout: NotificationLayout.Messaging),
  );
}

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
