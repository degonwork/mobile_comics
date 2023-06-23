import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/size_config.dart';
import '../../widgets/back_ground_app.dart';
import '../../widgets/text_ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // RepositoryProvider.of<DeviceRepo>(context).registerDevice();
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Center(
            child: TextUi(
              text: AppLocalizations.of(context)!.development,
              fontSize: SizeConfig.font18,
            ),
          ),
        ],
      ),
    );
  }
}
