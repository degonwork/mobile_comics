import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/text_ui.dart';

class SelectTitle extends StatelessWidget {
  final String title;
  final GestureTapCallback press;

  const SelectTitle({super.key, required this.title, required this.press});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextUi(
            text: title,
            fontSize: SizeConfig.font20,
            color: AppColor.titleSelectColor,
          ),
          GestureDetector(
            onTap: press,
            child: TextUi(
              text: AppLocalizations.of(context)!.seeMore,
              color: AppColor.buttonTextSelectColor,
              fontSize: SizeConfig.font16,
            ),
          ),
        ],
      ),
    );
  }
}
