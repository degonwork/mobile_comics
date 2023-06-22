import 'package:flutter/material.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/size_config.dart';

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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextUi(
          text: '${AppLocalizations.of(context)!.chapter} $numerical',
          fontSize: SizeConfig.font20,
        ),
      ),
    );
  }
}
