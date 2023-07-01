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
        super(GetInitial()) {
    on<GetAllCategory>(_getAllCategory);
  }
  Future<void> _getAllCategory(
      GetAllCategory event, Emitter<GetAllCategoryState> emitter) async {
    List<String> listCategoryString = [];
    List<Category> listCategories = [];
    try {
      listCategories = await _categoryRepo.getAllCategoryFromDB();
      if (listCategories.isEmpty) {
        print("Categories is empty --------------------");
        await _categoryRepo.getAllCategory();
        listCategories = await _categoryRepo.getAllCategoryFromDB();
        for (var category in listCategories) {
          listCategoryString.add(category.name);
        }
        emitter(GetLoadded(listCategoryString));
      } else {
        print("Categories is not empty --------------------");
        for (var category in listCategories) {
          listCategoryString.add(category.name);
        }
        emitter(GetLoadded(listCategoryString));
        await _categoryRepo.getAllCategory().whenComplete(
          () async {
            listCategoryString = [];
            await Future.delayed(const Duration(seconds: 1), () async {
              listCategories = await _categoryRepo.getAllCategoryFromDB();
              for (var category in listCategories) {
                listCategoryString.add(category.name);
              }
              emitter(GetLoadded(listCategoryString));
            });
          },
        );
      }
    } catch (e) {
      emitter(GetFailure());
    }
  }
}
