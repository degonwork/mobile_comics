import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/comic_model.dart';
import '../../read/read_screen.dart';
import '../../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../../config/size_config.dart';

class ListChapter extends StatelessWidget {
  const ListChapter({super.key, required this.comic});
  final Comic comic;

  @override
  Widget build(BuildContext context) {
    final chapters = comic.chapters;
    if (chapters!.isNotEmpty) {
      return Container(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
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
                        return const ReadScreen();
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
                      '${chapters.last.numerical}',
                      style: const TextStyle(fontSize: 30),
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
              Column(
                children: List.generate(
                  chapters.length,
                  (index) => Column(
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
                                return const ReadScreen();
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
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
}
