import 'package:flutter/material.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';
import '../../config/size_config.dart';

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
          fontWeight: FontWeight.w500,
        ),
        iconRightWidget ??
            Container(
              width: SizeConfig.width25,
            ),
      ],
    );
  }
}
