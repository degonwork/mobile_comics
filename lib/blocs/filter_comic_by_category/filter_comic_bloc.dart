import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/repository/category_repository.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';
import '../../data/models/category_model.dart';

class FilterComicBloc extends Bloc<FilterComicEvent, FilterComicState> {
  final ComicRepo _comicRepo;
  final CategoryRepo _categoryRepo;
  FilterComicBloc(
      {required ComicRepo comicRepo, required CategoryRepo categoryRepo})
      : _comicRepo = comicRepo,
        _categoryRepo = categoryRepo,
        super(FilterComicInital()) {
    on<FilterByIDCategory>(_filterByIDCategory);
    on<FilterComicStart>(_filterComicStart);
  }

  Future<void> _filterComicStart(
      FilterComicStart event, Emitter<FilterComicState> emitter) async {
    try {
      List<Category> listCategories =
          await _categoryRepo.getAllCategoryFromDB();
      List<Comic> comicIndexFirst = await _comicRepo.readComicByCategoryName(
          categoryName: listCategories[0].name);
      if (comicIndexFirst.isEmpty) {
        await _comicRepo.fetchAPIAndCreateFilterComicByCategories(
            categoryName: listCategories[0].name);
        List<Comic> comicIndexFirstResult = await _comicRepo
            .readComicByCategoryName(categoryName: listCategories[0].name);
        emitter(LoadedComicByCategoryID(comicIndexFirstResult));
      } else {
        emitter(LoadedComicByCategoryID(comicIndexFirst));
        // await _comicRepo
        //     .fetchAPIAndCreateFilterComicByCategories(
        //         categoryName: listCategories[0].name)
        //     .whenComplete(
        //   () async {
        //     List<Comic> comicIndexFirstResult = await _comicRepo
        //         .readComicByCategoryID(categoryName: listCategories[0].name);
        //     emitter(LoadedComicByCategoryID(comicIndexFirstResult));
        //   },
        // );
      }
    } catch (e) {
      emitter(FilterComicFailed());
    }
  }

  Future<void> _filterByIDCategory(
      FilterByIDCategory event, Emitter<FilterComicState> emitter) async {
    emitter(LoadingComicByCategory());
    try {
      List<Comic> listComics = await _comicRepo.readComicByCategoryName(
          categoryName: event.categoryName);
      if (listComics.isEmpty) {
        // await _comicRepo.fetchAPIAndCreateFilterComicByCategories(
        //     categoryName: event.categoryName);
        // List<Comic> listComicsResult = await _comicRepo.readComicByCategoryName(
        //     categoryName: event.categoryName);
        emitter(LoadedComicByCategoryID(listComics));
      } else {
        emitter(LoadedComicByCategoryID(listComics));
        // await _comicRepo
        //     .fetchAPIAndCreateFilterComicByCategories(
        //         categoryName: event.categoryName)
        //     .whenComplete(
        //   () async {
        //     List<Comic> listComicsResult = await _comicRepo
        //         .readComicByCategoryID(categoryName: event.categoryName);
        //     emitter(LoadedComicByCategoryID(listComicsResult));
        //   },
        // );
      }
    } catch (e) {
      emitter(FilterComicFailed());
    }
  }
}
