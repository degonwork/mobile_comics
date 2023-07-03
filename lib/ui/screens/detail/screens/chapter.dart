import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../blocs/ads/ads_bloc.dart';
import '../../../../data/models/case_comic_model.dart';
import '../../../../data/models/chapter_model.dart';
import '../../../../data/models/comic_model.dart';
import '../../../widgets/chapter_item.dart';
import '../../../widgets/text_ui.dart';
import '../../read/read_screen.dart';
import '../../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../../config/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListChapter extends StatelessWidget {
  const ListChapter({super.key, required this.comic, required this.caseComic});
  final Comic comic;
  final CaseComic caseComic;

  @override
  Widget build(BuildContext context) {
    final chapters = comic.chapters;
    if (chapters!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUi(
                text: AppLocalizations.of(context)!.latestChapter,
                color: AppColor.titleContentColor,
                fontSize: SizeConfig.font20,
              ),
              SizedBox(
                height: SizeConfig.height10,
              ),
              GestureDetector(
                  onTap: () {
                    context.read<AdsBloc>().add(Increment());
                    context.read<ReadChapterBloc>().add(
                          LoadChapter(chapters.last.id),
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadScreen(
                          comic: comic,
                          chapterId: chapters.last.id,
                          numericChapter: chapters.length,
                        ),
                      ),
                    );
                  },
                  child: ChapterItem(numerical: chapters.last.numerical!)),
              SizedBox(
                height: SizeConfig.height10,
              ),
              const Divider(thickness: 0.5),
              TextUi(
                text: AppLocalizations.of(context)!.listChapters,
                color: AppColor.titleContentColor,
                fontSize: SizeConfig.font20,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height10),
          Expanded(
            child: ScrollablePositionedList.builder(
              initialScrollIndex: caseComic.numericChapter != 0
                  ? _checkPositionScroll(caseComic.numericChapter, chapters)
                  : 0,
              itemCount: chapters.length,
              itemBuilder: (context, index) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<AdsBloc>().add(Increment());
                      context
                          .read<ReadChapterBloc>()
                          .add(LoadChapter(chapters[index].id));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                            context,
                          ) =>
                              ReadScreen(
                            comic: comic,
                            chapterId: chapters[index].id,
                            numericChapter: chapters[index].numerical,
                          ),
                        ),
                      );
                    },
                    child: ChapterItem(numerical: chapters[index].numerical),
                  ),
                  SizedBox(height: SizeConfig.height10),
                  const Divider(thickness: 1),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: SizeConfig.height200),
        child: TextUi(
          text: AppLocalizations.of(context)!.noChapters,
          color: AppColor.blackColor,
          fontSize: SizeConfig.font18,
        ),
      );
    }
  }

  int _checkPositionScroll(int position, List<Chapter> chapters) {
    if (chapters.length <= 6) {
      position = 0;
    } else {
      if (position < 6 ||
          position == 6 && 6 <= chapters.length - 5 ||
          position > 6 && position < chapters.length - 5) {
        position = position - 1;
      } else {
        position = chapters.length - 6;
      }
    }
    return position;
  }
}
