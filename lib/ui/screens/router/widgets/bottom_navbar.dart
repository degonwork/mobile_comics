import 'package:flutter/material.dart';
import '../../../../config/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  final Function(int) onTap;
  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.height60dot5,
      child: BottomNavigationBar(
        backgroundColor: Colors.black.withBlue(70),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        iconSize: SizeConfig.width25,
        selectedFontSize: SizeConfig.font14,
        unselectedFontSize: SizeConfig.font14,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_outlined,
            ),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.library_books,
            ),
            label: AppLocalizations.of(context)!.library,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.cases_outlined,
            ),
            label: AppLocalizations.of(context)!.cabinet,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
            ),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
