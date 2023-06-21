import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';
import 'package:full_comics_frontend/ui/widgets/gridview_comics.dart';
import '../../../../blocs/get_all_category_bloc/get_all_category_bloc.dart';
import '../../../../blocs/get_all_category_bloc/get_all_category_state.dart';

class ComicByCategory extends StatelessWidget {
  const ComicByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllCategoryBloc, GetAllCategoryState>(
      builder: (context, state) {
        if (state is GetLoadded) {
          return BlocBuilder<FilterComicBloc, FilterComicState>(
            builder: (context, state) {
              if (state is LoadedComicByCategoryID) {
                final listComicsFilter = state.listComics;
                if (listComicsFilter.isNotEmpty) {
                  return GridviewComics(listNewComics: listComicsFilter);
                } else {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.amber));
                }
              }
              return const Center(
                  child: CircularProgressIndicator(color: Colors.amber));
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(color: Colors.amber));
      },
    );
  }
}
