import '../../data/models/comic_model.dart';
import '../../data/providers/database/handle_database.dart';
import '../../data/repository/category_repository.dart';
import '../models/categoriescomics_model.dart';
import '../models/category_model.dart';

class CategoriesComicsRepo {
  final CategoryRepo _categoryRepo;

  CategoriesComicsRepo({required CategoryRepo categoryRepo})
      : _categoryRepo = categoryRepo;
  Future<void> processCategoriesComicsToDB(
      {required Comic comic, String? categoryName}) async {
    List<CategoriesComics> allCategoriesComicsByComicIDFromDB =
        await HandleDatabase.readAllCategoriesComicsFromDB(comicID: comic.id);
    if (allCategoriesComicsByComicIDFromDB.isNotEmpty) {
      await HandleDatabase.deleteAllCategoriesComicsByComicIDFromDB(
          comicID: comic.id);
      // print("deleted CategoriesComics with comicId: ${comic.id}");
    }
    List<CategoriesComics> listCategoriesComics = [];
    if (comic.categories!.isNotEmpty) {
      for (var i = 0; i < comic.categories!.length; i++) {
        final category = await _categoryRepo.readCategoryByNameFromDB(
            name: comic.categories![i]);
        if (category != null) {
          listCategoriesComics.add(
              CategoriesComics(comic_id: comic.id, category_id: category.id));
        }
      }
    } else if (categoryName != null) {
      Category? category =
          await _categoryRepo.readCategoryByNameFromDB(name: categoryName);
      if (category != null) {}
      listCategoriesComics.add(
        CategoriesComics(comic_id: comic.id, category_id: category!.id),
      );
    }
    if (listCategoriesComics.isNotEmpty) {
      await HandleDatabase.createCategoriesComicsToDB(
          categoriesComics: listCategoriesComics);
    }
   
  }

  Future<void> addListCategoriesComics({
    required String category,
    required List<CategoriesComics> listCategoriesComics,
    required Comic comic,
  }) async {
    Category? categoryDB =
        await _categoryRepo.readCategoryByNameFromDB(name: category);
    if (categoryDB != null) {
      String categoryId = categoryDB.id;
      CategoriesComics categoriesComics = CategoriesComics(
        comic_id: comic.id,
        category_id: categoryId,
      );
      listCategoriesComics.add(categoriesComics);
    }
  }
}
