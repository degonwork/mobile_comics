import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextUi extends StatelessWidget {
  final String text;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  TextAlign textAlign;

  TextUi({
    Key? key,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    required this.text,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontFamily: 'Raleway',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
