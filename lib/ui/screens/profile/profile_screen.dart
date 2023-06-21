import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import 'package:full_comics_frontend/ui/widgets/back_ground_app.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
