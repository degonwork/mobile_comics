import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/ads_bloc/ads_bloc.dart';
import '../../data/models/comic_model.dart';
import 'text_ui.dart';
import '../screens/read/read_screen.dart';
import '../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../blocs/read_chapter/read_chapter_event.dart';
import '../../config/size_config.dart';

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
      child: InkWell(
        onTap: () {
          context.read<AdsBloc>().add(Increment());
          if (comic != null && id != null && numericChapter != null) {
            context.read<ReadChapterBloc>().add(LoadChapter(id!));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadScreen(
                  comic: comic,
                  chapterId: id,
                  numericChapter: numericChapter,
                ),
              ),
            );
          }
        },
        child: Container(
          width: SizeConfig.width150,
          padding: EdgeInsets.symmetric(vertical: SizeConfig.height10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(SizeConfig.radius20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 0.1,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: TextUi(
            text: title,
            textAlign: TextAlign.center,
            fontSize: SizeConfig.font20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
