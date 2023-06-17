import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/repository/category_repository.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';

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
      final listCategories = await _categoryRepo.getAllCategoryFromDB();
      final comicIndexFirst =
          await _comicRepo.fetchAPIAndCreateFilterComicByCategories(
              categoryName: listCategories[0].name);
      emitter(LoadedComicByCategoryID(comicIndexFirst));
    } catch (e) {
      emitter(FilterComicFailed());
    }
  }

  Future<void> _filterByIDCategory(
      FilterByIDCategory event, Emitter<FilterComicState> emitter) async {
    try {
      List<Comic> listComics =
          await _comicRepo.fetchAPIAndCreateFilterComicByCategories(
              categoryName: event.categoryName);
      emitter(LoadedComicByCategoryID(listComics));
    } catch (e) {
      emitter(FilterComicFailed());
    }
  }
}
