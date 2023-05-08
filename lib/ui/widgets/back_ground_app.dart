import 'package:flutter/material.dart';

class BackGroundApp extends StatelessWidget {
  const BackGroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.cyan,
            Colors.indigo,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
