import 'package:flutter/material.dart';
import '../../../config/app_router.dart';
import '../../screens/auth/login/login_screen.dart';
import '../../../config/size_config.dart';
import 'widgets/banner_listview.dart';
import 'widgets/new_comic.dart';
import 'widgets/select_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.cyan,
                    Colors.indigo,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.screenHeight * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.screenWidth * 0.041,
                      right: SizeConfig.screenWidth * 0.041,
                      bottom: SizeConfig.screenHeight * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: SizeConfig.screenHeight * 0.066,
                            width: SizeConfig.screenWidth / 3,
                            decoration: BoxDecoration(
                              color: Colors.amberAccent.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                AppRouter.navigator(
                                  context,
                                  LoginScreen.routeName,
                                );
                              },
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.search_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications_active_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth * 0.041),
                            child: SelectTitle(
                              title: "Truyện hot",
                              press: () {},
                            ),
                          ),
                          const BannerListview(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth * 0.041),
                            child: SelectTitle(
                              title: "Truyện mới",
                              press: () {},
                            ),
                          ),
                          const NewComic(),
                          SizedBox(height: SizeConfig.screenHeight / 75.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
