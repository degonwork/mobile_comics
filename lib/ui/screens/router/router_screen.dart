import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../blocs/bottom_navbar/bottom_navbar_bloc.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../blocs/get_all_category/get_all_category_bloc.dart';
import '../../../blocs/get_all_category/get_all_category_event.dart';
import '../../../blocs/home/home_bloc.dart';
import '../../../data/providers/firebase/notification/firebase_messaging_service.dart';
import '../../../data/providers/firebase/notification/local_notification_service.dart';
import '../case/case_screen.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/bottom_navbar.dart';

Future<dynamic> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("Handling a background message ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});
  static const String routeName = '/router';

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () async {
        BlocProvider.of<GetAllCategoryBloc>(context)
            .add(const GetAllCategory());
        BlocProvider.of<CaseBloc>(context).add(const LoadCaseComic());
        await Firebase.initializeApp();
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
        LocalNotificationService.initialize(flutterLocalNotificationsPlugin);
        FireBaseMessagingService.subscribeTopicOnFirebase();
        FireBaseMessagingService.getMessage(
            channel, flutterLocalNotificationsPlugin);
        FireBaseMessagingService.createFireBaseTokenToLocal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listScreen = const [
      HomeScreen(),
      LibraryScreen(),
      CaseScreen(),
      ProfileScreen(),
    ];

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return BlocBuilder<BottomNavbarBloc, BottomNavbarState>(
          builder: (context, state) {
            return Scaffold(
              body: state.currentScreen,
              bottomNavigationBar: BottomNavbar(
                currentIndex: state.navigatorValue,
                onTap: (int value) {
                  context.read<BottomNavbarBloc>().add(
                        ChangeBottomNavbarEvent(
                          listScreen[value],
                          value,
                        ),
                      );
                },
              ),
            );
          },
        );
      },
    );
  }
}
