import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/back_ground_app.dart';
import '../../../config/app_router.dart';
import '../../../config/size_config.dart';
import '../router/router_screen.dart';

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
      () {
        AppRouter.navigator(context, RouterScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Stack(
      children: [
        const BackGroundApp(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Chào mừng bạn đến với App Truyện',
              textAlign: TextAlign.center,
              style: TextStyle(
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
    ));
  }
}
