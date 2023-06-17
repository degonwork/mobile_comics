import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/get_all_category_bloc/get_all_category_event.dart';
import 'package:full_comics_frontend/blocs/get_all_category_bloc/get_all_category_state.dart';
import 'package:full_comics_frontend/data/repository/category_repository.dart';

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
    try {
      final listCategories = await _categoryRepo.getAllCategory();
      emitter(GetLoadded(listCategories));
    } catch (e) {
      emitter(GetFailure());
    }
  }
}
