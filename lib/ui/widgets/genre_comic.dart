import 'package:flutter/material.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';

import '../../config/size_config.dart';
import '../../data/models/category_model.dart';

class GenreComic extends StatelessWidget {
  const GenreComic({
    super.key,
    required this.listCategories,
    required this.selected,
    required this.index,
    required this.color,
  });

  final List<Category> listCategories;
  final int? selected;
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
        border: Border.all(width: SizeConfig.radius1, color: Colors.grey),
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
              text: listCategories[index].name,
              fontSize: SizeConfig.font14,
            ),
          ),
        ),
      ),
    );
  }
}
