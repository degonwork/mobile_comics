import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  void init(BuildContext context) {
    Size mediaQueryData = MediaQuery.sizeOf(context);
    screenWidth = mediaQueryData.width;
    screenHeight = mediaQueryData.height;
  }

  // font
  static double font20 = screenWidth / 18;
  static double font18 = screenWidth / 20;
  static double font16 = screenWidth / 22.5;
  static double font14 = screenWidth / 25.71;

  // height
  static double height10 = screenHeight / 75.6;
  static double height15 = screenHeight / 50.4;
  static double height20 = screenHeight / 37.8;
  static double height40 = screenHeight / 18.9;
  static double height45 = screenHeight / 16.8;
  static double height60dot5 = screenHeight / 12.5;
  static double height180 = screenHeight / 4.2; //1.6

  // width

  static double width10 = screenWidth / 36;
  static double width20 = screenWidth / 18;
  static double width15 = screenWidth / 24;
  static double width25 = screenWidth / 14.4;
  static double width100 = screenWidth / 3.6;
  static double width230 = screenWidth / 1.57;

  // radius
  static double radius1 = screenWidth / 360;
  static double radius5 = screenWidth / 72;
  static double radius10 = screenWidth / 36;
}
