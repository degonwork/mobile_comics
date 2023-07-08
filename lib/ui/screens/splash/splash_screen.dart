import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../blocs/home/home_bloc.dart';
import '../../../config/app_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../blocs/get_all_category/get_all_category_bloc.dart';
import '../../../blocs/get_all_category/get_all_category_event.dart';
import '../../../config/size_config.dart';
import '../../../data/providers/firebase/notification/firebase_messaging_service.dart';
import '../../../data/providers/firebase/notification/local_notification_service.dart';
import '../../widgets/back_ground_app.dart';
import '../../../config/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/text_ui.dart';
import '../router/router_screen.dart';

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
      const Duration(seconds: 2),
      () async {
        AppRouter.navigator(context, RouterScreen.routeName);
        BlocProvider.of<GetAllCategoryBloc>(context)
            .add(const GetAllCategory());
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
          body: Stack(
            children: [
              const BackGroundApp(),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: SizeConfig.height100),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width15),
                        child: TextUi(
                          text:
                              AppLocalizations.of(context)!.welcomeSplashScreen,
                          fontSize: SizeConfig.font18dot5,
                          color: AppColor.titleSplashColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: SizeConfig.height150),
                      Container(
                        height: SizeConfig.height250,
                        width: SizeConfig.width250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.radius20,
                          ),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/anh splash.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
