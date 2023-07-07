import 'package:flutter/material.dart';
import '../../config/app_color.dart';
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
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeConfig.radius10,
            ),
            border: Border.all(width: 0.6, color: AppColor.blackColor)),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextUi(
                  text: titleItem,
                  fontSize: SizeConfig.font14,
                  color: AppColor.contentInforColor,
                ),
                Center(
                  child: TextUi(
                    textAlign: TextAlign.center,
                    text: contentItem,
                    fontSize: SizeConfig.font14,
                    color: AppColor.contentInforColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
