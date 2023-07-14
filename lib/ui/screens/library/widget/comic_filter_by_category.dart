import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../ui/widgets/text_ui.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_bloc.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_state.dart';
import '../../../../blocs/get_all_category/get_all_category_bloc.dart';
import '../../../../blocs/get_all_category/get_all_category_state.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/gridview_comics.dart';
import '../../../../config/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComicByCategory extends StatelessWidget {
  const ComicByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllCategoryBloc, GetAllCategoryState>(
        builder: (context, state) {
      if (state is GetAllCategoryLoaded) {
        return BlocBuilder<FilterComicBloc, FilterComicState>(
            builder: (context, state) {
          if (state is ComicByCategoryLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColor.circular));
          }
          if (state is ComicByCategoryLoaded) {
            final listComicsFilter = state.listComics;
            if (listComicsFilter.isNotEmpty) {
              return GridviewComics(listComics: listComicsFilter);
            }
          }
          return TextUi(
              text: AppLocalizations.of(context)!.notFoundComics,
              color: Colors.white,
              fontSize: SizeConfig.font16);
        });
      }
      return TextUi(
          text: AppLocalizations.of(context)!.notFoundComics,
          color: Colors.white,
          fontSize: SizeConfig.font16);
    });
  }
}
