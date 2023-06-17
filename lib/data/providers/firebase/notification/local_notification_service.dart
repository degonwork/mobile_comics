import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static void initialize(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(
    RemoteNotification notification,
    AndroidNotificationChannel channel,
    AndroidNotification? android,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android!.smallIcon,
          ),
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
