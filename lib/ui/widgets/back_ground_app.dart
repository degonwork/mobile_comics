import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_color.dart';

class BackGroundApp extends StatelessWidget {
  const BackGroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
    );
  }
}
