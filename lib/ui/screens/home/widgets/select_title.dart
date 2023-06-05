import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          child: Text(
            AppLocalizations.of(context)!.seeMore,
            style: const TextStyle(color: Colors.yellow),
          ),
        ),
      ],
    );
  }
}
