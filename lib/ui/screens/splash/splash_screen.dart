import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../data/providers/firebase/notification/firebase_messaging_service.dart';
import '../../../data/providers/firebase/notification/local_notification_service.dart';
import '../../../blocs/home/home_bloc.dart';
import '../../widgets/back_ground_app.dart';
import '../../../config/app_router.dart';
import '../../../config/size_config.dart';
import '../router/router_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<dynamic> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () async {
        AppRouter.navigator(context, RouterScreen.routeName);
        BlocProvider.of<CaseBloc>(context).add(const LoadCaseComic());
        await MobileAds.instance.initialize();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                const BackGroundApp(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeSplashScreen,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Image.asset(
                      'assets/images/banner_splash.png',
                      height: SizeConfig.screenHeight / 2.52,
                      width: SizeConfig.screenWidth / 1.2,
                    ),
                    Container(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
