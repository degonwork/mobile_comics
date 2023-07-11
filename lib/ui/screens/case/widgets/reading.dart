import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/case/case_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../config/app_color.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/case_infor.dart';
import '../../../widgets/text_ui.dart';
import '../../detail/comic_detail_screen.dart';

class Reading extends StatelessWidget {
  const Reading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseBloc, CaseState>(
      builder: (context, state) {
        if (state is CaseLoading) {
          return const Center(
              child:
              CircularProgressIndicator(color: AppColor.circular));
        }
        if (state is CaseLoaded) {
          final listCaseComic = state.listCaseComic;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width15),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: listCaseComic.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: index == listCaseComic.length - 1
                            ? EdgeInsets.only(
                                bottom: SizeConfig.height20,
                              )
                            : const EdgeInsets.only(bottom: 0),
                        child: GestureDetector(
                          onTap: () {
                            context.read<ComicDetailBloc>().add(
                                LoadDetailComic(listCaseComic[index].comicId));
                            Navigator.pushNamed(
                                context, ComicDetailScreen.routeName);
                          },
                          child: CaseInfor(
                            imageSquare: listCaseComic[index]
                                .imageThumnailSquareComicPath,
                            title: listCaseComic[index].titleComic,
                            reads: listCaseComic[index].reads,
                            numericChapter: listCaseComic[index].numericChapter,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: SizeConfig.height20,
                        )),
              ),
            );
          }
        return Center(
          child: TextUi(
            text: AppLocalizations.of(context)!.empty,
            fontSize: SizeConfig.font18,
          ),
        );
      },
    );
  }
}
