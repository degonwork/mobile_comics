import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../config/size_config.dart';

class BackButtonScreen extends StatelessWidget {
  const BackButtonScreen({
    super.key,
    required this.onTap,
  });
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as Function(),
      child: Container(
        height: SizeConfig.height35,
        width: SizeConfig.width35,
        margin: EdgeInsets.only(
          left: SizeConfig.width15,
          top: SizeConfig.height45,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.yellowColor.withOpacity(0.5),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: AppColor.iconAppbarColor,
          size: SizeConfig.icon20,
        ),
      ),
    );
  }
}
