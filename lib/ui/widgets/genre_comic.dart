import 'package:flutter/material.dart';
import '../../config/app_color.dart';
import '../../config/size_config.dart';
import 'text_ui.dart';

class GenreComic extends StatelessWidget {
  const GenreComic({
    super.key,
    required this.listCategories,
    required this.index,
    required this.color,
  });

  final List<String> listCategories;
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width100,
      margin: index != listCategories.length - 1
          ? EdgeInsets.only(
              right: SizeConfig.width10,
            )
          : const EdgeInsets.only(right: 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(
            SizeConfig.radius10,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(SizeConfig.radius5),
        child: Center(
          child: Center(
            child: TextUi(
              text: listCategories[index],
              fontSize: SizeConfig.font14,
              color: AppColor.genreComicColor,
            ),
          ),
        ),
      ),
    );
  }
}
