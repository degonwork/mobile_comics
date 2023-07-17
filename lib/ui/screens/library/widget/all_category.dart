import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../../ui/widgets/text_ui.dart';
import '../../../../blocs/get_all_category/get_all_category_event.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_bloc.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_event.dart';
import '../../../../blocs/get_all_category/get_all_category_bloc.dart';
import '../../../../blocs/get_all_category/get_all_category_state.dart';
import '../../../../config/app_color.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/genre_comic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllCategory extends StatelessWidget {
  const AllCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllCategoryBloc, GetAllCategoryState>(
      builder: (context, state) {
        if (state is GetAllCategoryLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColor.circular));
        }
        if (state is GetAllCategoryLoaded) {
          final listCategories = state.listCategories;
          final index = state.index;
          if (listCategories.isNotEmpty) {
            return SizedBox(
              height: SizeConfig.height40,
              child: ScrollablePositionedList.builder(
                initialScrollIndex: _checkPositionScroll(index, listCategories),
                scrollDirection: Axis.horizontal,
                itemCount: listCategories.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    context
                        .read<GetAllCategoryBloc>()
                        .add(SetStateCategoryIndex(index));
                    context.read<FilterComicBloc>().add(
                          FilterByIDCategory(listCategories[index]),
                        );
                  },
                  child: GenreComic(
                    listCategories: listCategories,
                    index: index,
                    color: state.index == index
                        ? AppColor.selectItemGenreComicColor
                        : AppColor.unSelectItemGenreComicolor.withOpacity(0.9),
                  ),
                ),
              ),
            );
          }
        }
        return Center(
          child: TextUi(
            text: AppLocalizations.of(context)!.notFoundCategory,
            color: Colors.white,
            fontSize: SizeConfig.font16,
          ),
        );
      },
    );
  }

  int _checkPositionScroll(int position, List<String> listCategoires) {
    if (position == 0) {
      return position;
    } else if (position > listCategoires.length - 2) {
      return position - 2;
    } else {
      return position - 1;
    }
  }
}
