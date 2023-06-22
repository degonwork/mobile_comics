import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../config/size_config.dart';
import 'text_ui.dart';

class ChapterItem extends StatelessWidget {
  const ChapterItem({
    super.key,
    required this.numerical,
  });
  final int? numerical;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 20,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth / 50),
      decoration: BoxDecoration(
        border: Border.all(width: SizeConfig.width0dot8),
        borderRadius: BorderRadius.circular(SizeConfig.radius10),
      ),
      child: Center(
        child: TextUi(
          text: numerical != null
              ? '${AppLocalizations.of(context)!.chapter} $numerical'
              : "${AppLocalizations.of(context)!.chapter}: ",
          fontSize: SizeConfig.font20,
          color: AppColor.contentInforColor,
        ),
      ),
    );
  }
}
