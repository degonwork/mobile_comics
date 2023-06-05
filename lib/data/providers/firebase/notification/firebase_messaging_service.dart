import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../.././firebase/notification/local_notification_service.dart';

class FireBaseMessagingService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  RemoteNotification? remoteNotification;

  static void subscribeTopicOnFirebase() {
    _fcm.subscribeToTopic("new-comics");
    _fcm.subscribeToTopic("hot-comics");
  }

  static Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  static void getMessage(AndroidNotificationChannel channel,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) async {
        print("Message receive frontground $remoteMessage");
        if (remoteMessage.notification != null &&
            remoteMessage.notification?.android != null) {
          LocalNotificationService.display(
            remoteMessage.notification!,
            channel,
            remoteMessage.notification?.android,
            flutterLocalNotificationsPlugin,
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage remoteMessage) {
        print("Message receive background $remoteMessage");
        if (remoteMessage.notification != null) {
          print(remoteMessage.notification!.title);
          print(remoteMessage.notification!.body);
        }
      },
    );
  }
}
