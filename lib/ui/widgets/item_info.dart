import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../config/size_config.dart';
import 'text_ui.dart';

class ItemInfor extends StatelessWidget {
  const ItemInfor({
    super.key,
    required this.icon,
    required this.titleItem,
    required this.contentItem,
  });

  final IconData icon;
  final String titleItem;
  final String contentItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.height45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.backGroundIconInforColor,
            radius: SizeConfig.radius15,
            child: Icon(
              icon,
              color: Colors.white,
              size: SizeConfig.icon20,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextUi(
                text: titleItem,
                fontSize: SizeConfig.font14,
                color: AppColor.contentInforColor,
              ),
              TextUi(
                text: contentItem,
                fontSize: SizeConfig.font14,
                color: AppColor.contentInforColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
