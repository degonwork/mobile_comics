import 'package:flutter/material.dart';

class SelectTitle extends StatelessWidget {
  final String title;
  final GestureTapCallback press;

  const SelectTitle({super.key, required this.title, required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: press,
          child: const Text(
            "Xem thêm",
            style: TextStyle(color: Colors.yellow),
          ),
        ),
      ],
    );
  }
}
