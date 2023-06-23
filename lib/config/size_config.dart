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
  static double font14 = screenWidth / 25.71;
  static double font16 = screenWidth / 22.5;
  static double font18 = screenWidth / 20;
  static double font20 = screenWidth / 18;
  static double font30 = screenWidth / 12;

  // height
  static double height5 = screenHeight / 151.2;
  static double height8 = screenHeight / 94.5;
  static double height10 = screenHeight / 75.6;
  static double height15 = screenHeight / 50.4;
  static double height17 = screenHeight / 44.5;
  static double height20 = screenHeight / 37.8;
  static double height35 = screenHeight / 21.6;
  static double height40 = screenHeight / 18.9;
  static double height45 = screenHeight / 16.8;
  static double height50 = screenHeight / 15.12;
  static double height80 = screenHeight / 9.45;
  static double height100 = screenHeight / 7.56;
  static double height180 = screenHeight / 4.2;
  static double height200 = screenHeight / 3.78;
  static double height435 = screenHeight / 1.74;

  // width
  static double width0dot8 = screenWidth / 450;
  static double width1 = screenWidth / 360;
  static double width8 = screenWidth / 45;
  static double width10 = screenWidth / 36;
  static double width20 = screenWidth / 18;
  static double width15 = screenWidth / 24;
  static double width25 = screenWidth / 14.4;
  static double width35 = screenWidth / 10.28;
  static double width50 = screenWidth / 7.2;
  static double width100 = screenWidth / 3.6;
  static double width150 = screenWidth / 2.4;
  static double width230 = screenWidth / 1.57;

  // radius

  static double radius1 = screenWidth / 360;
  static double radius5 = screenWidth / 72;
  static double radius10 = screenWidth / 36;
  static double radius15 = screenWidth / 24;
  static double radius20 = screenWidth / 18;
  static double radius100 = screenWidth / 3.6;

  // icon size
  static double icon25 = screenWidth / 14.4;
  static double icon20 = screenWidth / 18;
}
