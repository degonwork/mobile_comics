import 'package:flutter/material.dart';

import '../../../../config/size_config.dart';

// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.screenHeight * 0.1,
      width: double.infinity,
      child: BottomNavigationBar(
        backgroundColor: Colors.black.withBlue(50),
        unselectedItemColor: Colors.blue,
        iconSize: 28,
        showSelectedLabels: true,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white.withOpacity(0.9),
            ),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
              color: Colors.white.withOpacity(0.9),
            ),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cases_outlined,
              color: Colors.white.withOpacity(0.9),
            ),
            label: 'Tủ sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white.withOpacity(0.9),
            ),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}
