import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import 'package:full_comics_frontend/data/models/case_comic_model.dart';
import 'package:full_comics_frontend/ui/screens/detail/widgets/descreption.dart';

import '../../../../config/app_constant.dart';
import '../../../../data/models/comic_model.dart';
import '../../../../config/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/genre_comic.dart';
import '../../../widgets/item_info.dart';
import '../../../widgets/read_button.dart';
import '../../../widgets/text_ui.dart';

class Infor extends StatelessWidget {
  const Infor({
    super.key,
    required this.comic,required this.caseComic
  });
  final Comic comic;
  final CaseComic caseComic;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.height5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ItemInfor(
                        icon: Icons.remove_red_eye,
                        titleItem: AppLocalizations.of(context)!.numberReads,
                        contentItem:
                            comic.reads != null ? '${comic.reads}' : "",
                      ),
                    ),
                    SizedBox(width: SizeConfig.width10),
                    Expanded(
                      flex: 1,
                      child: ItemInfor(
                        icon: Icons.star,
                        titleItem: AppLocalizations.of(context)!.evaluate,
                        contentItem: AppConstant.evaluate,
                      ),
                    ),
                    SizedBox(width: SizeConfig.width10),
                    Expanded(
                      flex: 1,
                      child: ItemInfor(
                        icon: Icons.library_books,
                        titleItem: AppLocalizations.of(context)!.totalChapters,
                        contentItem: comic.chapters!.isNotEmpty
                            ? comic.chapters!.length.toString()
                            : "",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1),
            SizedBox(
              height: SizeConfig.screenHeight / 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUi(
                    text: AppLocalizations.of(context)!.genreComics,
                    color: AppColor.titleContentColor,
                    fontSize: SizeConfig.font20,
                  ),
                  SizedBox(height: SizeConfig.height10),
                  Expanded(
                    child: comic.categories!.isNotEmpty
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GenreComic(
                              listCategories: comic.categories!,
                              index: index,
                              color: AppColor.backGroundGenreComicColor,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 0),
                            itemCount: comic.categories!.length,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.height10),
            const Divider(thickness: 1),
            TextUi(
              text: AppLocalizations.of(context)!.describe,
              color: AppColor.titleContentColor,
              fontSize: SizeConfig.font20,
            ),
            SizedBox(height: SizeConfig.height10),
            SizedBox(
              height: SizeConfig.height120,
              child: SingleChildScrollView(
                child: Descreption(
                  maxLines: 2,
                  text: comic.description != null ? comic.description! : "",
                ),
              ),
            ),
            SizedBox(height: SizeConfig.height20,),
            _loadReadButton(context),
            // LoadReabutton(),
          ],
        ),
      ),
    );
  }
   Widget _loadReadButton(BuildContext context) {
    if (comic.chapters!.isNotEmpty) {
      if (caseComic != AppConstant.caseComicNotExist) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReadButton(
              id: comic.chapters!.first.id,
              comic: comic,
              // numericChapter: 1,
              color: Colors.orangeAccent,
              title: AppLocalizations.of(context)!.readFirstChapter,
            ),
            ReadButton(
              id: caseComic.chapterId,
              comic: comic,
              // numericChapter: caseComic.numericChapter,
              color: Colors.orangeAccent,
              title: AppLocalizations.of(context)!.continueReading,
            ),
          ],
        );
      } else {
        return Center(
          child: ReadButton(
            id: comic.chapters!.first.id,
            comic: comic,
            // numericChapter: 1,
            color: Colors.orangeAccent,
            title: AppLocalizations.of(context)!.readComics,
          ),
        );
      }
    } else {
      return ReadButton(
          title: AppLocalizations.of(context)!.readComics, color: Colors.grey);
    }
  } 
}
