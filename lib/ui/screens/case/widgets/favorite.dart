import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/text_ui.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextUi(
        text: AppLocalizations.of(context)!.development,
        color: Colors.black,
        fontSize: SizeConfig.font18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
