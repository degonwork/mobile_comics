import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../read/read_screen.dart';
import '../../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../../config/size_config.dart';

class ReadButton extends StatelessWidget {
  const ReadButton({super.key, this.id, required this.color});
  final String? id;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: SizeConfig.screenHeight / 12.6,
        width: SizeConfig.screenWidth / 1.8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextButton(
            onPressed: () {
              if (id != null) {
                context.read<ReadChapterBloc>().add(LoadChapter(id!));
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
              } else {
                print("Chapter has not content");
              }
            },
            child: const Text(
              'Đọc truyện',
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
      ),
    );
  }
}
