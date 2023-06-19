import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/ads_bloc/ads_bloc.dart';
import '../../../../data/models/comic_model.dart';
import '../../read/read_screen.dart';
import '../../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../../config/size_config.dart';

class ReadButton extends StatelessWidget {
  const ReadButton({
    super.key,
    this.id,
    required this.color,
    required this.title,
    this.comic,
    this.numericChapter,
  });
  final String? id;
  final Comic? comic;
  final Color color;
  final String title;
  final int? numericChapter;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: SizeConfig.screenHeight / 12.6,
        width: SizeConfig.screenWidth / 3,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          boxShadow:  [
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 0.1,
              spreadRadius: 0.5,
              // offset: Offset(-4, -4),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            context.read<AdsBloc>().add(Increment());
            if (comic != null && id != null && numericChapter != null) {
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
                    return ReadScreen(
                      comic: comic,
                      chapterId: id,
                      numericChapter: numericChapter,
                    );
                  },
                ),
              );
            }
          },
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
