// primary color
import 'package:flutter/material.dart';

class AppColor {
// Primary
  static const blackColor = Color(0xFF26292B);
  static const brownColor = Color(0xFF3D3A50);
  static const blueColor = Color(0xFF5F7ADB);
  static const blueAccentColor = Color(0xFFA2B2EE);
  static const whiteColor = Color(0xFFFEF4F4);
  static const yellowColor = Color(0xFFF0EC8B);
  static const greenColor = Color(0xFFADDFAD);
  static const blueWaterColor = Color(0xFF580EF6);
  static const violetColor = Color(0xFF8E43ED);
  static const redColor = Color(0xFFF65151);
  static const pinkColor = Color(0xFFFF6EC7);

// Ui color
// Background app
  static const backGroundColor = LinearGradient(
    colors: [blueColor, blueAccentColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // title
  static const titleSplashColor = whiteColor;
  static const titleSelectColor = blackColor;
  static const titleComicColor = whiteColor;
  static const titleContentColor = whiteColor;
  static const titleAppbarColor = blackColor;

  // content
  static const contentInforColor = brownColor;
  static const contentDecripberColor = blackColor;
  static const contentButtonColor = whiteColor;
  static const caseReadsColor = yellowColor;
  static const genreComicColor = blackColor;

  // select
  static const selectItemColor = blueWaterColor;
  static const selectItemGenreComicColor = pinkColor;
  static const unSelectItemGenreComicolor = yellowColor;
  static const selectTitleColor = yellowColor;
  static const unSelectItemColor = brownColor;
  static const unSelectTitleColor = blackColor;
  static const buttonTextSelectColor = yellowColor;

  // icon
  static const iconAppbarColor = brownColor;

  // background widget
  static const navbarColor = blueAccentColor;
  static const backGroundIconBackColor = whiteColor;
  static const backGroundIconInforColor = violetColor;
  static const backGroundGenreComicColor = yellowColor;
  static const backGroundButtonColor = redColor;

  // circular
  static const circular = violetColor;
  // disable
  static const disable = Colors.grey;
}
