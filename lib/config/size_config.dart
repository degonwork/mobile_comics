import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
  }

  // font
  static double font20 = screenWidth / 20.57;
  static double font16 = screenWidth / 25.71;
  static double font14 = screenWidth / 29.39;
  static double font12 = screenWidth / 34.29;
}
