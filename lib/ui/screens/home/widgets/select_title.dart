import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';

import '../../../../config/size_config.dart';

class SelectTitle extends StatelessWidget {
  final String title;
  final GestureTapCallback press;

  const SelectTitle({super.key, required this.title, required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextUi(
          text: title,
          fontSize: SizeConfig.font20, // 20
          fontWeight: FontWeight.w500,
        ),
        TextButton(
          onPressed: press,
          child: TextUi(
            text: AppLocalizations.of(context)!.seeMore,
            color: Colors.yellow,
            fontSize: SizeConfig.font16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
