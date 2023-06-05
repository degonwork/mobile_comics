import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../data/models/case_comic_model.dart';
import '../../../../data/models/chapter_model.dart';
import '../../../../data/models/comic_model.dart';
import '../../read/read_screen.dart';
import '../../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../../config/size_config.dart';

class ListChapter extends StatelessWidget {
  const ListChapter({super.key, required this.comic, required this.caseComic});
  final Comic comic;
  final CaseComic caseComic;

  @override
  Widget build(BuildContext context) {
    final chapters = comic.chapters;
    if (chapters!.isNotEmpty) {
      return Container(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight / 50),
                const Text(
                  'Mới nhất',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: SizeConfig.screenHeight / 50),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ReadChapterBloc>()
                        .add(LoadChapter(chapters.last.id));
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        transitionsBuilder:
                            (context, animation, secAnimation, child) {
                          return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secAnimation) {
                          return ReadScreen(
                            comic: comic,
                            chapterId: chapters.last.id,
                            numericChapter: chapters.length,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: SizeConfig.screenHeight / 20,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth / 50),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Chapter ${chapters.last.numerical}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Danh sách',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_list_outlined,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: ScrollablePositionedList.builder(
                  initialScrollIndex: caseComic.numericChapter != 0
                      ? _checkPositionScroll(caseComic.numericChapter, chapters)
                      : 0,
                  itemCount: chapters.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ReadChapterBloc>()
                              .add(LoadChapter(chapters[index].id));
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                              transitionsBuilder:
                                  (context, animation, secAnimation, child) {
                                return ScaleTransition(
                                  scale: animation,
                                  alignment: Alignment.center,
                                  child: child,
                                );
                              },
                              pageBuilder: (context, animation, secAnimation) {
                                return ReadScreen(
                                  comic: comic,
                                  chapterId: chapters[index].id,
                                  numericChapter: chapters[index].numerical,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: SizeConfig.screenHeight / 20,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Chapter ${chapters[index].numerical}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight / 90,
                      ),
                      const Divider(thickness: 1),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 200),
        child: Text(
          "This comic has no chapters",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
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
