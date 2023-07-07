import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_color.dart';
import '../../blocs/ads/ads_bloc.dart';
import '../../data/models/case_comic_model.dart';
import '../../data/models/comic_model.dart';
import 'text_ui.dart';
import '../screens/read/read_screen.dart';
import '../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../blocs/read_chapter/read_chapter_event.dart';
import '../../config/size_config.dart';

class ReadButton extends StatelessWidget {
  const ReadButton({
    super.key,
    required this.chapterId,
    required this.color,
    required this.title,
    required this.comic,
    this.caseComic,
  });
  final String chapterId;
  final Comic comic;
  final Color color;
  final String title;
  final CaseComic? caseComic;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          context.read<AdsBloc>().add(Increment());
          if (caseComic != null) {
            context.read<ReadChapterBloc>().add(ContinueReading(caseComic!));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadScreen(
                  comic: comic,
                ),
              ),
            );
          } else {
            context.read<ReadChapterBloc>().add(LoadChapter(chapterId));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadScreen(
                  comic: comic,
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
            color: AppColor.contentButtonColor,
          ),
        ),
      ),
    );
  }
}
