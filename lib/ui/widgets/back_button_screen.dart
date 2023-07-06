import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../config/size_config.dart';

class NavigatorButtonScreen extends StatelessWidget {
  const NavigatorButtonScreen({
    super.key,
    required this.onTap, required this.icon,
  });
  final Function onTap;
  final IconData icon;
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
          icon,
          color: AppColor.iconAppbarColor,
          size: SizeConfig.icon20,
        ),
      ),
    );
  }
}
