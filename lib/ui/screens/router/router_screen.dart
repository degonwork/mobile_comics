import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/app_color.dart';
import '../../../config/size_config.dart';
import '../../../ui/widgets/text_ui.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../blocs/get_all_category/get_all_category_bloc.dart';
import '../../../blocs/get_all_category/get_all_category_state.dart';
import '../../../blocs/home/home_bloc.dart';
import '../../../blocs/router/router_bloc.dart';
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
        return BlocBuilder<GetAllCategoryBloc, GetAllCategoryState>(
          builder: (context, state) {
            return BlocBuilder<RouterBloc, RouterState>(
              builder: (context, state) {
                if (state is RouterLoaded) {
                  return Scaffold(
                    body: state.currentScreen,
                    bottomNavigationBar: BottomNavbar(
                      currentIndex: state.navigatorValue,
                      onTap: (int value) {
                        context.read<RouterBloc>().add(
                              ChangeBottomNavBar(
                                listScreen[value],
                                value,
                              ),
                            );
                      },
                    ),
                  );
                }
                return Scaffold(
                  body: Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight / 2),
                    child: Center(
                      child: Column(
                        children: [
                          TextUi(
                            text: AppLocalizations.of(context)!.navBarError,
                            fontSize: SizeConfig.font20,
                          ),
                          TextButton(
                            child: TextUi(
                              text: AppLocalizations.of(context)!.reset,
                              color: AppColor.blueColor,
                            ),
                            onPressed: () {
                              context.read<RouterBloc>().add(
                                  const ResetBottomNavBar(HomeScreen(), 0));
                              Navigator.pushNamed(
                                  context, RouterScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
