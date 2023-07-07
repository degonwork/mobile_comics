import 'package:flutter/material.dart';
import '../../config/app_color.dart';
import '../../config/size_config.dart';
import 'text_ui.dart';

class CustomAppbar extends StatelessWidget {
  final Widget? iconleftWidget;
  final Widget? iconRightWidget;
  final String text;
  const CustomAppbar({
    super.key,
    this.iconleftWidget,
    this.iconRightWidget,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        iconleftWidget ??
            Container(
              width: SizeConfig.width25,
            ),
        TextUi(
          text: text,
          fontSize: SizeConfig.font20,
          color: AppColor.titleAppbarColor,
        ),
        iconRightWidget ??
            Container(
              width: SizeConfig.width25,
            ),
      ],
    );
  }
}
