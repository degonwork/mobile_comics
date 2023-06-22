import 'package:flutter/material.dart';
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black45,
          size: SizeConfig.icon20,
        ),
      ),
    );
  }
}
