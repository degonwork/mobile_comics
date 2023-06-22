import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/get_all_category_bloc/get_all_category_event.dart';
import 'package:full_comics_frontend/blocs/get_all_category_bloc/get_all_category_state.dart';
import 'package:full_comics_frontend/data/repository/category_repository.dart';

import '../../data/models/category_model.dart';

class GetAllCategoryBloc
    extends Bloc<GetAllCategoryEvent, GetAllCategoryState> {
  final CategoryRepo _categoryRepo;
  GetAllCategoryBloc(CategoryRepo categoryRepo)
      : _categoryRepo = categoryRepo,
        super(GetInitial()) {
    on<GetAllCategory>(_getAllCategory);
  }
  Future<void> _getAllCategory(
      GetAllCategory event, Emitter<GetAllCategoryState> emitter) async {
    List<String> listCategoryString = [];
    try {
      List<Category> listCategories =
          await _categoryRepo.getAllCategoryFromDB();

      if (listCategories.isEmpty) {
        await _categoryRepo.getAllCategory();
        List<Category> listCategoriesResult =
            await _categoryRepo.getAllCategoryFromDB();
        for (var category in listCategoriesResult) {
          listCategoryString.add(category.name);
        }
        emitter(GetLoadded(listCategoryString));
      } else {
        for (var category in listCategories) {
          listCategoryString.add(category.name);
        }
        emitter(GetLoadded(listCategoryString));
        // await _categoryRepo.getAllCategory().whenComplete(
        //   () async {
        //     List<Category> listCategoriesResult =
        //         await _categoryRepo.getAllCategoryFromDB();
        //     emitter(GetLoadded(listCategoriesResult));
        //   },
        // );
      }
    } catch (e) {
      emitter(GetFailure());
    }
  }
}
