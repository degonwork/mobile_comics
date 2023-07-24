import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category_model.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/category_repository.dart';
import '../../data/repository/comic_repository.dart';
import 'filter_comic_event.dart';
import 'filter_comic_state.dart';

class FilterComicBloc extends Bloc<FilterComicEvent, FilterComicState> {
  final ComicRepo _comicRepo;
  final CategoryRepo _categoryRepo;

  FilterComicBloc(
      {required ComicRepo comicRepo, required CategoryRepo categoryRepo})
      : _comicRepo = comicRepo,
        _categoryRepo = categoryRepo,
        super(FilterComicInital()) {
    on<FilterComicStart>(_filterComicStart);
    on<FilterByIDCategory>(_filterByIDCategory);
  }

  Future<void> _filterComicStart(
      FilterComicStart event, Emitter<FilterComicState> emitter) async {
    emitter(ComicByCategoryLoading());
    List<Comic> comicIndexFirst = [];
    List<Category> listCategories = await _categoryRepo.getAllCategoryFromDB();
    if (listCategories.isNotEmpty) {
      comicIndexFirst = await _comicRepo.readComicByCategoryName(
          categoryName: listCategories[0].name);
      if (comicIndexFirst.isEmpty) {
        try {
          await _comicRepo.fetchAPIAndCreateFilterComicByCategories(
              categoryName: listCategories[0].name, isUpdate: false);
          comicIndexFirst = await _comicRepo.readComicByCategoryName(
              categoryName: listCategories[0].name);
          emitter(ComicByCategoryLoaded(comicIndexFirst));
        } catch (e) {
          emitter(ComicByCategoryLoadError());
        }
      } else {
        emitter(ComicByCategoryLoaded(comicIndexFirst));
        await _comicRepo
            .fetchAPIAndCreateFilterComicByCategories(
                categoryName: listCategories[0].name, isUpdate: true)
            .whenComplete(() async {
          
              comicIndexFirst = await _comicRepo.readComicByCategoryName(
                  categoryName: listCategories[0].name);
              emitter(ComicByCategoryLoaded(comicIndexFirst));
            },
        );
      }
    } else {
      emitter(ComicByCategoryLoadError());
    }
  }

  Future<void> _filterByIDCategory(
      FilterByIDCategory event, Emitter<FilterComicState> emitter) async {
    emitter(ComicByCategoryLoading());
    List<Comic> listComicsFilter = [];
    listComicsFilter = await _comicRepo.readComicByCategoryName(
        categoryName: event.categoryName);
    if (listComicsFilter.isEmpty) {
      try {
        await _comicRepo.fetchAPIAndCreateFilterComicByCategories(
            categoryName: event.categoryName, isUpdate: false);
        listComicsFilter = await _comicRepo.readComicByCategoryName(
            categoryName: event.categoryName);
        emitter(ComicByCategoryLoaded(listComicsFilter));
      } catch (e) {
        emitter(ComicByCategoryLoadError());
      }
    } else {
      emitter(ComicByCategoryLoaded(listComicsFilter));
      await _comicRepo
          .fetchAPIAndCreateFilterComicByCategories(
              categoryName: event.categoryName, isUpdate: true)
          .whenComplete(() async {
        
          listComicsFilter = await _comicRepo.readComicByCategoryName(
              categoryName: event.categoryName);
          emitter(ComicByCategoryLoaded(listComicsFilter));
        }
      );
    }
  }
}
