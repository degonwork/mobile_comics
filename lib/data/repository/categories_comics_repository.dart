import 'package:uuid/uuid.dart';
import '../../data/models/comic_model.dart';
import '../../data/providers/database/handle_database.dart';
import '../../data/repository/category_repository.dart';
import '../models/categoriescomics_model.dart';

class CategoriesComicsRepo {
  final CategoryRepo _categoryRepo;

  CategoriesComicsRepo({required CategoryRepo categoryRepo})
      : _categoryRepo = categoryRepo;
  Future<void> processCategoriesComicsToDB(Comic comic) async {
    List<CategoriesComics>? allCategoriesComicsByComicIDFromDB =
        await HandleDatabase.readAllCategoriesComicsFromDB(comicID: comic.id);
    if (allCategoriesComicsByComicIDFromDB != null) {
      await HandleDatabase.deleteAllCategoriesComicsByComicIDFromDB(
          comicID: comic.id);
      print("deleted");
    }
    List<CategoriesComics>? listCategoriesComic = [];
    for (String category in comic.categories!) {
      int? i = await _categoryRepo.createCategoryToDB(category);
      if (i != null) {
        print("${i + 1}: Category created");
        String categoryId =
            (await _categoryRepo.readCategoryByNameFromDB(name: category))!.id;
        CategoriesComics categoriesComics = CategoriesComics(
          id: const Uuid().v4(),
          comic_id: comic.id,
          category_id: categoryId,
        );
        listCategoriesComic.add(categoriesComics);
      } else {
        print("${i! + 1}: Category don't create");
        String categoryId =
            (await _categoryRepo.readCategoryByNameFromDB(name: category))!.id;
        CategoriesComics categoriesComics = CategoriesComics(
          id: const Uuid().v4(),
          comic_id: comic.id,
          category_id: categoryId,
        );
        listCategoriesComic.add(categoriesComics);
      }
    }
    if (listCategoriesComic.isNotEmpty) {
      await HandleDatabase.createCategoriesComicsToDB(
          categoriesComics: listCategoriesComic);
    }
    print("--------------------------------");
  }
}
