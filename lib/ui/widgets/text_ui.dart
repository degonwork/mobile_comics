import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextUi extends StatelessWidget {
  final String text;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  TextAlign textAlign;
  int? maxLines;
  TextOverflow? textOverflow;

  TextUi({
    Key? key,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    required this.text,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.clip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
