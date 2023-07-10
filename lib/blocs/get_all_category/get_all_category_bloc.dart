import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category_model.dart';
import '../../data/repository/category_repository.dart';
import 'get_all_category_event.dart';
import 'get_all_category_state.dart';

class GetAllCategoryBloc
    extends Bloc<GetAllCategoryEvent, GetAllCategoryState> {
  final CategoryRepo _categoryRepo;

  GetAllCategoryBloc(CategoryRepo categoryRepo)
      : _categoryRepo = categoryRepo,
        super(GetAllCategoryInitial()) {
    on<GetAllCategory>(_getAllCategory);
    on<SetStateCategoryIndex>(_setStateIndexCategory);
  }

  Future<void> _getAllCategory(
      GetAllCategory event, Emitter<GetAllCategoryState> emitter) async {
    List<String> listCategoryString = [];
    List<Category> listCategories = [];
    listCategories = await _categoryRepo.getAllCategoryFromDB();
    emitter(GetAllCategoryLoading());
    if (listCategories.isEmpty) {
      print("Categories is empty --------------------");
      try {
        await _categoryRepo.getAllCategory();
        listCategories = await _categoryRepo.getAllCategoryFromDB();
        for (var category in listCategories) {
          listCategoryString.add(category.name);
        }
        emitter(GetAllCategoryLoaded(listCategoryString, 0));
      } catch(e) {
        emitter(GetAllCategoryLoadError());
      }
    } else {
      print("Categories is not empty --------------------");
      for (var category in listCategories) {
        listCategoryString.add(category.name);
      }
      emitter(GetAllCategoryLoaded(listCategoryString, 0));
      await _categoryRepo.getAllCategory().whenComplete(
        () async {
          listCategoryString = [];
          await Future.delayed(const Duration(seconds: 1), () async {
            listCategories = await _categoryRepo.getAllCategoryFromDB();
            for (var category in listCategories) {
              listCategoryString.add(category.name);
            }
            emitter(
              GetAllCategoryLoaded(listCategoryString, 0),
            );
          });
        },
      );
    }
  }

  void _setStateIndexCategory(
      SetStateCategoryIndex event, Emitter<GetAllCategoryState> emit) {
    if (state is GetAllCategoryLoaded) {
      emit(GetAllCategoryLoaded(
          (state as GetAllCategoryLoaded).listCategories, event.index));
    }
  }
}
