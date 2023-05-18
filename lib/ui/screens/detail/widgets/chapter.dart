import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../.././screens/detail/widgets/read.dart';
import '../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../../config/size_config.dart';

class ListChapter extends StatelessWidget {
  const ListChapter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicDetailBloc, ComicDetailState>(
      builder: (context, state) {
        if (state is ComicDetailLoaded) {
          final chapter = state.comic.chapters;
          print(chapter!.last.id);
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
                          .add(LoadChapter(chapter.last.id));
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
                          '${chapter.last.numerical}',
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
                        chapter.length,
                        (index) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ReadChapterBloc>()
                                        .add(LoadChapter(chapter[index].id));
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                        transitionsBuilder: (context, animation,
                                            secAnimation, child) {
                                          return ScaleTransition(
                                            scale: animation,
                                            alignment: Alignment.center,
                                            child: child,
                                          );
                                        },
                                        pageBuilder:
                                            (context, animation, secAnimation) {
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
                                        'Chapter ${chapter[index].numerical}',
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
                            )),
                  ),
                  // Column(
                  //   children: List.generate(
                  //     2,
                  //     (index) => Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 10),
                  //       child: Row(
                  //         children: [
                  //           Container(
                  //             height: SizeConfig.screenHeight / 6,
                  //             width: 100,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(5),
                  //               // image: DecorationImage(
                  //               //   image: NetworkImage(
                  //               //       '"https://upload.wikimedia.org/wikipedia/vi/b/b7/Doraemon1.jpg"'),
                  //               //   fit: BoxFit.fill,
                  //               // ),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 18),
                  //           Text(
                  //             '',
                  //             style: const TextStyle(
                  //                 color: Colors.black, fontSize: 18),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
