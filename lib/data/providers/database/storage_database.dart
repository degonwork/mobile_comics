import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/categoriescomics_model.dart';
import '../../models/category_model.dart';
import '../../models/chapter_model.dart';
import '../../models/comic_model.dart';
import '../../models/image_model.dart';

class StorageDatabase {
  StorageDatabase._init();
  static final StorageDatabase instance = StorageDatabase._init();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    {
      _database = await _initDB('storage.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $tableComics(
      ${ComicField.id} TEXT,
      ${ComicField.image_detail_id} TEXT,
      ${ComicField.image_thumnail_square_id} TEXT, 
      ${ComicField.image_thumnail_rectangle_id} TEXT, 
      ${ComicField.title} TEXT, 
      ${ComicField.description} TEXT, 
      ${ComicField.author} TEXT, 
      ${ComicField.year} INTEGER, 
      ${ComicField.reads} INTEGER, 
      ${ComicField.chapter_update_time} TEXT,
      ${ComicField.update_time} TEXT,
      ${ComicField.add_chapter_time} TEXT,
      ${ComicField.isFull} INTEGER
    ) 
    ''');
    await db.execute(''' 
      CREATE TABLE $tableChapters(
      ${ChapterField.id} TEXT,
      ${ChapterField.comic_id} TEXT,
      ${ChapterField.image_thumnail_id} TEXT, 
      ${ChapterField.chapter_des} TEXT, 
      ${ChapterField.numerical} INTEGER,
      ${ChapterField.content_update_time} TEXT,
      ${ChapterField.update_time} TEXT,
      ${ChapterField.isFull} INTEGER
    ) 
    ''');
    await db.execute(''' 
      CREATE TABLE $tableImages(
      ${ImageField.id} TEXT,
      ${ImageField.path} TEXT,
      ${ImageField.type} TEXT,
      ${ImageField.height} INTEGER,
      ${ImageField.width} INTEGER,
      ${ImageField.parent_id} TEXT,
      ${ImageField.numerical} INTEGER
    ) 
    ''');
    await db.execute(''' 
      CREATE TABLE $tableCategories(
      ${CategoryField.id} TEXT,
      ${CategoryField.name} TEXT
    ) 
    ''');
    await db.execute(''' 
      CREATE TABLE $tableCategoriesComics(
      ${CategoriesComicsField.comic_id} TEXT,
      ${CategoriesComicsField.category_id} TEXT
    ) 
    ''');
  }

  // Process comic
  Future<void> createComicToDB({required Comic comic}) async {
    final db = await instance.database;
    final map = comic.toMap();
    await db.insert(tableComics, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Comic>> readManyComicsFromDB() async {
    final db = await instance.database;
    final maps = await db.query(tableComics, columns: ComicField.values);
    
    if (maps.isNotEmpty) {
      return maps.map((json) => Comic.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<Comic?> readComicByIDFromDB({required String id}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableComics,
      columns: ComicField.values,
      where: '${ComicField.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Comic.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateComicToDB({required Comic comic}) async {
    final db = await instance.database;
    final map = comic.toMap();
    await db.update(
      tableComics,
      map,
      where: '${ComicField.id} = ?',
      whereArgs: [comic.id],
    );
  }

  // Process chapter
  Future<void> createChapterToDB({required Chapter chapter}) async {
    final db = await instance.database;
    final map = chapter.toMap();
    await db.insert(tableChapters, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Chapter?> readChapterByIDFromDB({required String id}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableChapters,
      columns: ChapterField.values,
      where: '${ChapterField.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Chapter.fromJson(maps.first);
    } else {
      return null;
    }
  }
  //
   Future<Chapter?> readChapterByNumberic({required String comicId,required int numerical})async{
  final db= await instance.database;
  final maps = await db.query(
    tableChapters,
    columns: ChapterField.values,
    where: '${ChapterField.comic_id} = ? and ${ChapterField.numerical}  = ?',
    whereArgs: [comicId,numerical],
    );
   if (maps.isNotEmpty) {
     return Chapter.fromJson(maps.first);
   }else{
    return null;
   }
 }
  //
  Future<List<Chapter>> readChapterByComicIDFromDB(
      {required String comicID}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableChapters,
      columns: ChapterField.values,
      where: '${ChapterField.comic_id} =?',
      whereArgs: [comicID],
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => Chapter.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateChapterToDB({required Chapter chapter}) async {
    final db = await instance.database;
    final map = chapter.toMap();
    await db.update(
      tableChapters,
      map,
      where: '${ChapterField.id} = ?',
      whereArgs: [chapter.id],
    );
  }

  // Process image
  Future<void> createImageToDB({required Image image}) async {
    final db = await instance.database;
    final map = image.toMap();
    await db.insert(tableImages, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Image?> readImageFromDB(
      {required String type, required String parentId, int? numerical}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableImages,
      columns: ImageField.values,
      where: numerical == null
          ? '${ImageField.type} = ? and ${ImageField.parent_id} = ?'
          : '${ImageField.type} = ? and ${ImageField.parent_id} = ? and ${ImageField.numerical} = ?',
      whereArgs:
          numerical == null ? [type, parentId] : [type, parentId, numerical],
    );
    if (maps.isNotEmpty) {
      return Image.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Image>> readManyImageFromDB(
      {required String type, required String parentId}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableImages,
      columns: ImageField.values,
      where: '${ImageField.type} = ? and ${ImageField.parent_id} = ?',
      whereArgs: [type, parentId],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Image.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateImageToDB({required Image image}) async {
    final db = await instance.database;
    final map = image.toMap();
    await db.update(
      tableImages,
      map,
      where: '${ImageField.id} = ?',
      whereArgs: [image.id],
    );
  }

  Future<void> deleteImageFromDB(
      {required String type, required String parentId}) async {
    final db = await instance.database;
    await db.delete(
      tableImages,
      where: '${ImageField.type} = ? and ${ImageField.parent_id} = ?',
      whereArgs: [type, parentId],
    );
  }

  // Process category

  Future<int?> createCategoryToDB({required Category category}) async {
    final db = await instance.database;
    final map = category.toMap();
    return await db.insert(tableCategories, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Category?> readCategoryByNameFromDB({required String name}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategories,
      columns: CategoryField.values,
      where: '${CategoryField.name} = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<CategoriesComics>> readCategoriesComicByIDCategory(
      {required String categoryId}) async {
    final db = await instance.database;
    final maps = await db.query(tableCategoriesComics,
        columns: CategoriesComicsField.values,
        where: '${CategoriesComicsField.category_id} = ?',
        whereArgs: [categoryId]);

    if (maps.isNotEmpty) {
      return maps.map((e) => CategoriesComics.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<Category?> readCategoryByIDFromDB({required String id}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategories,
      columns: CategoryField.values,
      where: '${CategoryField.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Category>> readAllCategoryFromDB() async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategories,
      columns: CategoryField.values,
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => Category.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // Process categories Comics
  Future<void> createCategoriesComicsToDB(
      {required CategoriesComics categoriesComics}) async {
    final db = await instance.database;
    final map = categoriesComics.toMap();
    await db.insert(tableCategoriesComics, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<CategoriesComics?> readCategoriesComicsFromDB(
      {required String categoryID, required String comicID}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategoriesComics,
      columns: CategoriesComicsField.values,
      where:
          '${CategoriesComicsField.category_id} = ? and ${CategoriesComicsField.comic_id} = ?',
      whereArgs: [categoryID, comicID],
    );
    if (maps.isNotEmpty) {
      return CategoriesComics.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<CategoriesComics>> readAllCategoriesComicsDFromDB(
      {required String comicID}) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategoriesComics,
      where: '${CategoriesComicsField.comic_id} = ?',
      whereArgs: [comicID],
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => CategoriesComics.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteAllCategoriesComicsByComicIDFromDB(
      {required String comicID}) async {
    final db = await instance.database;
    await db.delete(
      tableCategoriesComics,
      where: '${CategoriesComicsField.comic_id} = ?',
      whereArgs: [comicID],
    );
  }

  Future<void> deleteCategoriesComicsByComicIDFromDB(
      {required String comicID, required String categoryId}) async {
    final db = await instance.database;
    await db.delete(
      tableCategoriesComics,
      where:
          '${CategoriesComicsField.comic_id} = ? and ${CategoriesComicsField.category_id} = ?',
      whereArgs: [comicID, categoryId],
    );
  }
}
