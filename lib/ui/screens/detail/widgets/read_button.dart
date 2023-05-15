import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_state.dart';
import 'package:full_comics_frontend/config/size_config.dart';

class ReadButton extends StatelessWidget {
  const ReadButton({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<ReadChapterBloc,ReadChapterState>
   (
    builder: (context,state){
      if (state is LoadedChapter) {
        final chapter = state.chapter;
        return Center(
               child: Container(
                        height: SizeConfig.screenHeight / 12.6,
                        width: SizeConfig.screenWidth / 1.8,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextButton(
                            onPressed: () {
                              
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     transitionDuration:
                              //         const Duration(milliseconds: 400),
                              //     transitionsBuilder:
                              //         (context, animation, secAnimation, child) {
                              //       return ScaleTransition(
                              //         scale: animation,
                              //         alignment: Alignment.center,
                              //         child: child,
                              //       );
                              //     },
                              //     pageBuilder:
                              //         (context, animation, secAnimation) {
                              //       return const ReadScreen();
                              //     },
                              //   ),
                              // );
                              // // navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => const ReadScreen()));
                            },
                            child: const Text(
                              'Đọc truyện',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                      ),
        );
      }
      return const SizedBox.shrink();
    }
   );
  }
}