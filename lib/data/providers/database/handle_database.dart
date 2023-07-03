import '../../models/categoriescomics_model.dart';
import '../../models/category_model.dart';
import '../../models/chapter_model.dart';
import '../../providers/database/storage_database.dart';
import '../../models/comic_model.dart';
import '../../models/image_model.dart';

class HandleDatabase {
  // process comic
  static Future<void> createComicToDB({required List<Comic> listComics}) async {
    for (int i = 0; i < listComics.length; i++) {
      Comic? comic = await readComicByIDFromDB(id: listComics[i].id);
      if (comic == null) {
        await StorageDatabase.instance.createComicToDB(comic: listComics[i]);
        print("${i + 1}: Comic created");
      } else {
        print("${i + 1}: Comic don't create");
      }
    }
  }
  // print("--------------------------------"); }

  static Future<List<Comic>> readManyComicsFromDB() async {
    List<Comic> listComics =
        await StorageDatabase.instance.readManyComicsFromDB();
    return listComics;
  }

  static Future<List<CategoriesComics>> readCategoriesComicByCategoryID(
      {required String categoryId}) async {
    final listCategoriesComics = await StorageDatabase.instance
        .readCategoriesComicByIDCategory(categoryId: categoryId);

    return listCategoriesComics;
  }

  static Future<Comic?> readComicByIDFromDB({required String id}) async {
    Comic? comic = await StorageDatabase.instance.readComicByIDFromDB(id: id);
    return comic;
  }

  static Future<void> updateComicToDB({required Comic comic}) async {
    await StorageDatabase.instance.updateComicToDB(comic: comic);
  }

  // process chapter
  static Future<void> createChapterToDB(
      {required List<Chapter> chapters}) async {
    for (int i = 0; i < chapters.length; i++) {
      Chapter? chapter = await readChapterByIDFromDB(id: chapters[i].id);
      if (chapter == null) {
        await StorageDatabase.instance.createChapterToDB(chapter: chapters[i]);
        print("${i + 1}: Chapter created");
      } else {
        print("${i + 1}: Chapter dont't create");
      }
    }
  }

  static Future<Chapter?> readChapterByIDFromDB({required String id}) async {
    Chapter? chapter =
        await StorageDatabase.instance.readChapterByIDFromDB(id: id);
    return chapter;
  }
  static Future<Chapter?> readNextChapterByNumberic({required String comicId, required int numerical})async{
    Chapter? chapters = await StorageDatabase.instance.readChapterByNumberic(comicId: comicId, numerical: numerical);
    return chapters;
  }
  static Future<void> updateChapterToDB({required Chapter chapter}) async {
    await StorageDatabase.instance.updateChapterToDB(chapter: chapter);
  }

  static Future<List<Chapter>> readChapterByComicIDFromDB(
      {required String comicID}) async {
    List<Chapter> listChapter = await StorageDatabase.instance
        .readChapterByComicIDFromDB(comicID: comicID);
    return listChapter;
  }

  // process image
  static Future<void> createImageToDB({required List<Image> images}) async {
    for (int i = 0; i < images.length; i++) {
      Image? imagesFromDB = await readImageFromDB(
        type: images[i].type,
        parentID: images[i].parent_id,
        numerical: images[i].numerical,
      );
      if (imagesFromDB == null) {
        await StorageDatabase.instance.createImageToDB(image: images[i]);
        print("${i + 1}: ${images[i].type} created");
      } else {
        print("${i + 1}: ${images[i].type} don't create");
      }
    }
  }

  static Future<Image?> readImageFromDB(
      {required String type, required String parentID, int? numerical}) async {
    Image? image = await StorageDatabase.instance.readImageFromDB(
      type: type,
      parentId: parentID,
      numerical: numerical,
    );
    return image;
  }

  static Future<List<Image>> readManyImageFromDB(
      {required String type, required String parentID}) async {
    List<Image> listImages = await StorageDatabase.instance
        .readManyImageFromDB(type: type, parentId: parentID);
    return listImages;
  }

  static Future<void> updateImageToDB({required Image image}) async {
    await StorageDatabase.instance.updateImageToDB(image: image);
  }

  static Future<void> deleteImageToDB(
      {required String type, required String parentID}) async {
    await StorageDatabase.instance
        .deleteImageFromDB(type: type, parentId: parentID);
  }

  // process category
  static Future<void> createCategoryToDB(
      {required List<Category> listCategories}) async {
    for (int i = 0; i < listCategories.length; i++) {
      Category? createCategory =
          await readCategoryByIDFromDB(id: listCategories[i].id);
      if (createCategory == null) {
        await StorageDatabase.instance
            .createCategoryToDB(category: listCategories[i]);
        print("Categories created");
      } else {
        print("Category dont create");
      }
    }
  }

  static Future<Category?> readCategoryByIDFromDB({required String id}) async {
    Category? category =
        await StorageDatabase.instance.readCategoryByIDFromDB(id: id);
    return category;
  }

  static Future<Category?> readCategoryByNameFromDB(
      {required String name}) async {
    Category? category =
        await StorageDatabase.instance.readCategoryByNameFromDB(name: name);
    return category;
  }

  static Future<List<Category>> readAllCategoryFromDB() async {
    List<Category>? listCategories =
        await StorageDatabase.instance.readAllCategoryFromDB();
    return listCategories;
  }

  // process categories-comics
  static Future<void> createCategoriesComicsToDB(
      {required List<CategoriesComics> categoriesComics}) async {
    for (int i = 0; i < categoriesComics.length; i++) {
      CategoriesComics? categoryComic = await readCategoriesComicsFromDB(
          comicID: categoriesComics[i].comic_id,
          categoryID: categoriesComics[i].category_id);
      if (categoryComic == null) {
        await StorageDatabase.instance
            .createCategoriesComicsToDB(categoriesComics: categoriesComics[i]);
        print("${i + 1}: CategoriesComics created");
      } else {
        print("${i + 1}: CategoriesComics don't create");
      }
    }
    //   print("--------------------------------");
  }

  static Future<List<CategoriesComics>> readAllCategoriesComicsFromDB(
      {required String comicID}) async {
    List<CategoriesComics>? listCategoriesComics = await StorageDatabase
        .instance
        .readAllCategoriesComicsDFromDB(comicID: comicID);
    return listCategoriesComics;
  }

  static Future<CategoriesComics?> readCategoriesComicsFromDB(
      {required String categoryID, required String comicID}) async {
    CategoriesComics? categoriesComics = await StorageDatabase.instance
        .readCategoriesComicsFromDB(categoryID: categoryID, comicID: comicID);
    return categoriesComics;
  }

  static Future<void> deleteAllCategoriesComicsByComicIDFromDB(
      {required String comicID}) async {
    await StorageDatabase.instance
        .deleteAllCategoriesComicsByComicIDFromDB(comicID: comicID);
  }

  static Future<void> deleteCategoriesComicsByComicIDFromDB(
      {required String comicID, required String categoryId}) async {
    await StorageDatabase.instance.deleteCategoriesComicsByComicIDFromDB(
        comicID: comicID, categoryId: categoryId);
  }
}
