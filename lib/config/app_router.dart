import 'package:flutter/material.dart';
import '../ui/screens/detail/comic_detail_screen.dart';
import '../ui/screens/view_more/new_comics_view_more/new_comics_view_more/new_comics_view_more_screen.dart';
import '../ui/screens/auth/login/login_screen.dart';
import '../ui/screens/auth/signup/signup_screen.dart';
import '../ui/screens/router/router_screen.dart';
import '../ui/screens/splash/splash_screen.dart';

class AppRouter {
  static final routes = {
    SplashScreen.routeName: (_) => const SplashScreen(),
    RouterScreen.routeName: (_) => const RouterScreen(),
    LoginScreen.routeName: (_) => const LoginScreen(),
    SignUpScreen.routeName: (_) => const SignUpScreen(),
    ComicDetailScreen.routeName: (_) => const ComicDetailScreen(),
    NewComicViewMoreScreen.routeName: (_) => const NewComicViewMoreScreen(),
  };

  static navigator(BuildContext context, String routeName) {
    Widget screen = routes[routeName]!.call(context);
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) => screen,
      ),
    );
  }
}
