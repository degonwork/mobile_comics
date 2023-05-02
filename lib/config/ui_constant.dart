import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Colors.deepPurpleAccent,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);
TextStyle kProductStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.017,
    );

const String saledName = "Hàng trong kho ";
const Color yellowColor = Color(0xfffed813); //Yellow

const Color activeCyanColor = Color(0xff0a7c97);

const Color backgroundColor = Color(0xffebecee);

const List<Color> backgroundGradient = [
  Color(0xff80d9e9),
  Color(0xffa0e9ce),
]; //Cyan, and a mix of Cyan and Green

const List<Color> lightBackgroundaGradient = [
  Color(0xffa2e0eb),
  Color.fromARGB(255, 200, 228, 218),
];
const double kAppBarHeight = 80;
