import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/comic_detail/comic_detail_bloc.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';
import '../../../../blocs/case/case_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/case_infor.dart';
import '../../detail/comic_detail_screen.dart';

class Reading extends StatelessWidget {
  const Reading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseBloc, CaseState>(
      builder: (context, state) {
        if (state is CaseLoaded) {
          final listCaseComic = state.listCaseComic;
          if (listCaseComic.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width15),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: listCaseComic.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      context
                          .read<ComicDetailBloc>()
                          .add(LoadDetailComic(listCaseComic[index].comicId));
                      Navigator.pushNamed(context, ComicDetailScreen.routeName);
                    },
                    child: CaseInfor(
                      imageSquare:
                          listCaseComic[index].imageThumnailSquareComicPath,
                      title: listCaseComic[index].titleComic,
                      reads: listCaseComic[index].reads,
                      numericChapter: listCaseComic[index].numericChapter,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.green,
                  thickness: 0.5,
                ),
              ),
            );
          }
        }
        return Center(
          child: TextUi(
            text: AppLocalizations.of(context)!.empty,
            fontSize: SizeConfig.font18,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
