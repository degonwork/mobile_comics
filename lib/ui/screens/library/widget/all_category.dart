import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/get_all_category_bloc/get_all_category_bloc.dart';
import 'package:full_comics_frontend/blocs/get_all_category_bloc/get_all_category_state.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_bloc.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_event.dart';
import '../../../widgets/genre_comic.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({super.key});

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  int? selected = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllCategoryBloc, GetAllCategoryState>(
      builder: (context, state) {
        if (state is GetLoadded) {
          final listCategories = state.listCategories;
          if (listCategories.isNotEmpty) {
            return SizedBox(
              height: SizeConfig.height40,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    listCategories.length,
                    (index) => InkWell(
                          onTap: () {
                            context.read<FilterComicBloc>().add(
                                  FilterByIDCategory(listCategories[index]),
                                );
                            setState(() {
                              selected = index;
                            });
                          },
                          child: GenreComic(
                            listCategories: listCategories,
                            index: index,
                            color: selected == index
                                ? Colors.orange.withOpacity(0.8)
                                : Colors.blue.withOpacity(0.4),
                          ),
                        )),
              ),
            );
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
}
