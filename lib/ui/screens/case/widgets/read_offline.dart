import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/app_color.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/text_ui.dart';

class ReadOffline extends StatelessWidget {
  const ReadOffline({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextUi(
        text: AppLocalizations.of(context)!.development,
        color: AppColor.blackColor,
        fontSize: SizeConfig.font18,
      ),
    );
  }
}
