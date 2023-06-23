import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bottom_navbar_bloc/bottom_navbar_bloc.dart';
import '../case/case_screen.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/bottom_navbar.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});
  static const String routeName = '/router';

  @override
  Widget build(BuildContext context) {
    List<Widget> listScreen = const [
      HomeScreen(),
      LibraryScreen(),
      CaseScreen(),
      ProfileScreen(),
    ];

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
  }
}
