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
  static double font20 = screenWidth / 18;
  static double font16 = screenWidth / 22.5;
  static double font14 = screenWidth / 25.71;
}
