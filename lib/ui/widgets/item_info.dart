import 'package:flutter/material.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';

import '../../config/size_config.dart';

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
    return Container(
      height: SizeConfig.height45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(
            SizeConfig.radius15,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
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
              ),
              TextUi(
                text: contentItem,
                fontSize: SizeConfig.font14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
