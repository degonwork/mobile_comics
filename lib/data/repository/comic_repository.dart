import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/models/categoriescomics_model.dart';
import 'package:full_comics_frontend/data/models/category_model.dart';
import 'package:full_comics_frontend/data/providers/database/handle_database.dart';
import 'package:full_comics_frontend/data/repository/categories_comics_repository.dart';
import 'package:full_comics_frontend/data/repository/category_repository.dart';
import 'package:full_comics_frontend/data/repository/chapter_repository.dart';
import 'package:full_comics_frontend/data/repository/image_repository.dart';
import '../dummy/dummy_data.dart';
import '../models/chapter_model.dart';
import '../models/comic_model.dart';
import '../models/image_model.dart';
import '../providers/api/api_client.dart';

class ComicRepo {
  final ApiClient _apiClient;
  final String _comicUrl;
  final ImageRepo _imageRepo;
  final ChapterRepo _chapterRepo;
  final CategoriesComicsRepo _categoriesComicsRepo;
  ComicRepo({
    required ApiClient apiClient,
    required String comicUrl,
    required ImageRepo imageRepo,
    required ChapterRepo chapterRepo,
    required CategoriesComicsRepo categoriesComicsRepo,
  })  : _chapterRepo = chapterRepo,
        _imageRepo = imageRepo,
        _comicUrl = comicUrl,
        _categoriesComicsRepo = categoriesComicsRepo,
        _apiClient = apiClient;

  // Fetch Api
  Future<List<HomeComic>?> fetchAPIAndCreateDBHotComics(
      {required int limit}) async {
    // final response =
    // await _apiClient
    //     .getData('$_comicUrl${AppConstant.HOTCOMICURL}?limit=$limit');
    // if (response.statusCode == 200) {
    // List<dynamic> jsonResponse = jsonDecode(response.body);
    try {
      List<dynamic> jsonResponse = listHotComicJson;
      final listHotComicApi =
          jsonResponse.map((e) => HomeComic.fromJson(e)).toList();
      await createComicToDB(listHotComicApi);
      List<HomeComic>? listHotComics =
          await readHotComicsFromDB(limit: AppConstant.LIMIT);
      // Image? image = await HandleDatabase.readImageFromDB(
      // type: AppConstant.TYPEIMAGEHOMECOMICS[0], parentID: "hotcomic1");
      // print(image!.path);
      return listHotComics;
    } catch (e) {
      print(e.toString());
    }
    return null;

    // }

    // else {
    //   throw Exception('Load failed');
    // }
  }

  Future<List<HomeComic>?> fetchAPIAndCreateDBNewComics(
      {required int limit}) async {
    // final response =
    // await _apiClient
    //     .getData('$_comicUrl${AppConstant.NEWCOMICURL}?limit=$limit');
    // if (response.statusCode == 200) {
    // List<dynamic> jsonResponse = jsonDecode(response.body);
    try {
      List<dynamic> jsonResponse = listNewComicJson;
      final listNewComicsApi =
          jsonResponse.map((e) => HomeComic.fromJson(e)).toList();
      await createComicToDB(listNewComicsApi);
      List<HomeComic>? listNewComics =
          await readNewComicsFromDB(limit: AppConstant.LIMIT);
      // Image? image = await HandleDatabase.readImageFromDB(
      //     type: AppConstant.TYPEIMAGEHOMECOMICS[0], parentID: "newcomic1");
      // print(image!.path);
      return listNewComics;
    } catch (e) {
      print(e.toString());
    }
    return null;
    // }
    // else {
    //   throw Exception('Load failed');
    // }
  }

  Future fetchDetailComics({required String id}) async {
    // final response =
    // await _apiClient.getData('$_comicUrl/$id');
    // if (response.statusCode == 200) {
    // dynamic jsonResponse = jsonDecode(response.body);
    try {
      dynamic jsonResponse = detailComicJson;
      final comic = Comic.fromJson(jsonResponse);
      // await updateComicToDB(comic);
      // List<CategoriesComics>? listCategoriesComics =
      //     await HandleDatabase.readAllCategoriesComicsFromDB(comicID: comic.id);
      // for (var element in listCategoriesComics!) {
      //   print(element.category_id);
      // }
      // List<Category>? listCategories =
      //     await HandleDatabase.readAllCategoryFromDB();
      // for (var element in listCategories!) {
      //   print(element.name);
      // }
      // var chapter = await HandleDatabase.readChapterByIDFromDB(id: "chapter1");
      // print(chapter!.content_update_time);

      // Image? image = await HandleDatabase.readImageFromDB(
      //     type: AppConstant.TYPEIMAGETHUMNAILCHAPTER, parentID: "chapter1");
      // print(image!.path);
    } catch (e) {
      print(e.toString());
    }

    // }
    // else {
    // throw Exception('Load failed');
    // }
  }

  // Process Database
  // Create
  Future<void> createComicToDB(List<HomeComic> listHomeComic) async {
    await _imageRepo.createImageHomeComicToDB(listHomeComic);
    List<Comic>? listComics = [];
    for (var homeComic in listHomeComic) {
      List<String> listIDImage =
          await _imageRepo.readAllIDImageComicFromDB(comicId: homeComic.id);
      Comic comic = Comic(
        id: homeComic.id,
        title: homeComic.title,
        image_detail_id: listIDImage[0],
        image_thumnail_square_id: listIDImage[1],
        image_thumnail_rectangle_id: listIDImage[2],
        add_chapter_time: homeComic.add_chapter_time,
        reads: homeComic.reads,
      );
      listComics.add(comic);
    }
    await HandleDatabase.createComicToDB(comics: listComics);
  }

  // Update
  Future<void> updateComicToDB(Comic comic) async {
    await _categoriesComicsRepo.processCategoriesComicsToDB(comic);
    Comic? comicDB = await HandleDatabase.readComicByIDFromDB(id: comic.id);
    await _imageRepo.updateImageToDB(Image(
      id: comicDB!.image_detail_id!,
      path:
          comic.image_detail!.split("${AppConstant.IMAGEHOMEURL}").removeLast(),
      parent_id: comicDB.id,
      type: AppConstant.TYPEIMAGEHOMECOMICS[0],
    ));
    await _imageRepo.updateImageToDB(Image(
      id: comicDB.image_thumnail_square_id!,
      path: comic.image_thumnail_square!
          .split("${AppConstant.IMAGEHOMEURL}")
          .removeLast(),
      parent_id: comicDB.id,
      type: AppConstant.TYPEIMAGEHOMECOMICS[1],
    ));
    await _imageRepo.updateImageToDB(
      Image(
        id: comicDB.image_thumnail_rectangle_id!,
        path: comic.image_thumnail_rectangle!
            .split("${AppConstant.IMAGEHOMEURL}")
            .removeLast(),
        parent_id: comicDB.id,
        type: AppConstant.TYPEIMAGEHOMECOMICS[2],
      ),
    );
    Comic updateComic = Comic(
      id: comic.id,
      image_detail_id: comicDB.image_detail_id,
      image_thumnail_rectangle_id: comicDB.image_thumnail_rectangle_id,
      image_thumnail_square_id: comicDB.image_thumnail_square_id,
      title: comic.title,
      author: comic.author,
      description: comic.description,
      year: comic.year,
      reads: comic.reads,
      chapter_update_time: comic.chapter_update_time,
      add_chapter_time: comic.add_chapter_time,
      update_time: comic.update_time,
    );
    await HandleDatabase.updateComicToDB(updateComic);
    await _chapterRepo.createChapterToDB(comic.chapters!);
  }

  // Read Home comic
  Future<List<HomeComic>?> readHotComicsFromDB({required int limit}) async {
    List<HomeComic>? listHotComics = [];
    List<Comic>? listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics != null) {
      listComics.sort((comic1, comic2) => comic2.reads! - comic1.reads!);
      for (Comic comic in listComics) {
        listHotComics
            .addAll([await HomeComic.copyWith(await Comic.copyWith(comic))]);
      }
      limit = limit > listComics.length ? listComics.length : limit;
      return listHotComics.sublist(0, limit);
    } else {
      return null;
    }
  }

  Future<List<HomeComic>?> readNewComicsFromDB({required int limit}) async {
    List<HomeComic> listNewComics = [];
    List<Comic>? listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics != null) {
      listComics.sort((comic1, comic2) =>
          (comic2.add_chapter_time!.millisecondsSinceEpoch -
              comic1.add_chapter_time!.millisecondsSinceEpoch));
      for (Comic comic in listComics) {
        listNewComics
            .addAll([await HomeComic.copyWith(await Comic.copyWith(comic))]);
      }
      limit = limit > listComics.length ? listComics.length : limit;
      return listNewComics.sublist(0, limit);
    } else {
      return null;
    }
  }
}
