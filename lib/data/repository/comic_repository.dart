import 'dart:async';
import 'dart:convert';
import '../../data/models/case_comic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constant.dart';
import '../../data/providers/database/handle_database.dart';
import '../../data/repository/categories_comics_repository.dart';
import '../../data/repository/chapter_repository.dart';
import '../../data/repository/image_repository.dart';
import '../models/categoriescomics_model.dart';
import '../models/category_model.dart';
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
  Future<void> fetchAPIAndCreateDBHotComics({required int limit}) async {
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.hotComicUrl}?limit=$limit');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final listHotComicApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          await createComicToDB(listHomeComic: listHotComicApi);
          setTimesAds(listHotComicApi[0].times_ads);
        } else {
          print("Hot comic is not available");
          throw Exception("Not Found Data");
        }
      } else {
        print("load failed");
        throw Exception('Load failed hot comic');
      }
    } catch (e) {
      print("------------" + e.toString());
    }
  }

  Future<void> fetchAPIAndCreateDBNewComics({required int limit}) async {
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.newComicUrl}?limit=$limit');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final listNewComicsApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          await createComicToDB(listHomeComic: listNewComicsApi);
        } else {
          print("New comic is not available");
          throw Exception("Not Found Data");
        }
      } else {
        throw Exception('Load failed new comic');
      }
    } catch (e) {
      print("------------" + e.toString());
    }
  }

  Future<void> fetchDetailComics({required String id}) async {
    try {
      final response = await _apiClient.getData('$_comicUrl$id');
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          final comicApi = Comic.fromJson(jsonResponse);
          await updateComicToDB(comic: comicApi);
        } else {
          print("comic is not available");
          throw Exception("Not Found Data");
        }
      } else {
        throw Exception('Load failed comic detail');
      }
    } catch (e) {
      print(e.toString() + "-----------------------------");
    }
  }

  Future<void> fetchAPIAndCreateFilterComicByCategories(
      {required String categoryName}) async {
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.category}$categoryName');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final listComicFilterApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          await createComicToDB(listHomeComic: listComicFilterApi);
          for (var comicFilter in listComicFilterApi) {
            await _categoriesComicsRepo.processCategoriesComicsToDB(
                comic: comicFilter, categoryName: categoryName);
          }
        } else {
          print("Comic filter is not available");
          throw Exception("Not Found Data");
        }
      } else {
        throw Exception('Load failed comic filter');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Comic>> readComicByCategoryName(
      {required String categoryName}) async {
    Category? category =
        await HandleDatabase.readCategoryByNameFromDB(name: categoryName);

    if (category != null) {
      return readComicByCategoryIDFromDB(id: category.id);
    }
    return [];
  }

  // Process Database
  // Create
  Future<void> createComicToDB({required List<Comic> listHomeComic}) async {
    await _imageRepo.createImageComicToDB(listHomeComic: listHomeComic);
    List<Comic> listComics = [];
    for (var homeComic in listHomeComic) {
      String? imageDetailId = await _imageRepo.readIDImageFromDB(
        parentId: homeComic.id,
        typeImage: AppConstant.typeImageComic[0],
      );
      String? imageThumnailSquareId = await _imageRepo.readIDImageFromDB(
        parentId: homeComic.id,
        typeImage: AppConstant.typeImageComic[1],
      );
      String? imageThumnailRectangleId = await _imageRepo.readIDImageFromDB(
        parentId: homeComic.id,
        typeImage: AppConstant.typeImageComic[2],
      );
      Comic comic = Comic(
        id: homeComic.id,
        title: homeComic.title,
        image_detail_id: imageDetailId,
        image_thumnail_square_id: imageThumnailSquareId,
        image_thumnail_rectangle_id: imageThumnailRectangleId,
        add_chapter_time: homeComic.add_chapter_time,
        reads: homeComic.reads,
        isFull: homeComic.isFull,
      );
      listComics.add(comic);
    }
    await HandleDatabase.createComicToDB(comics: listComics);
  }

  // Update
  Future<void> updateComicToDB({required Comic comic}) async {
    Comic? comicDB = await HandleDatabase.readComicByIDFromDB(id: comic.id);
    if (comicDB != null) {
      await _categoriesComicsRepo.processCategoriesComicsToDB(comic: comic);
      String? imageDetailId = await _imageRepo.createOrUpdateImage(
        imageID: comicDB.image_detail_id,
        imagePath: comic.image_detail_path,
        parentDB: comicDB,
        typeImage: AppConstant.typeImageComic[0],
        parent: comic,
      );
      String? imageThumnailSquareId = await _imageRepo.createOrUpdateImage(
        imageID: comicDB.image_thumnail_square_id,
        imagePath: comic.image_thumnail_square_path,
        parentDB: comicDB,
        typeImage: AppConstant.typeImageComic[1],
        parent: comic,
      );
      String? imageThumnailRectangleId = await _imageRepo.createOrUpdateImage(
        imageID: comicDB.image_thumnail_rectangle_id,
        imagePath: comic.image_thumnail_rectangle_path,
        parentDB: comicDB,
        typeImage: AppConstant.typeImageComic[2],
        parent: comic,
      );
      Comic updateComic = Comic(
        id: comic.id,
        image_detail_id: imageDetailId,
        image_thumnail_rectangle_id: imageThumnailRectangleId,
        image_thumnail_square_id: imageThumnailSquareId,
        title: comic.title,
        author: comic.author,
        description: comic.description,
        year: comic.year,
        reads: comic.reads,
        chapter_update_time: comic.chapter_update_time,
        add_chapter_time: comic.add_chapter_time,
        update_time: comic.update_time,
        isFull: 1,
      );
      await HandleDatabase.updateComicToDB(comic: updateComic);
      print("Comic is updated");
      await _chapterRepo.createChapterToDB(comic: comic);
    } else {
      print("Comic is not updated");
    }
  }

  // Read Home comic
  Future<List<Comic>> readHotComicsFromDB({required int limit}) async {
    List<Comic> listHotComics = [];
    List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics.isNotEmpty) {
      List<Comic> listHotComicsFilter =
          listComics.where((comic) => comic.reads != null).toList();
      if (listHotComicsFilter.isNotEmpty) {
        listHotComicsFilter
            .sort((comic1, comic2) => (comic2.reads! - comic1.reads!));
        for (Comic comic in listHotComicsFilter) {
          listHotComics.add(await readHomeComicCopy(comic));
        }
        limit = limit > listHotComics.length ? listHotComics.length : limit;
        return listHotComics.sublist(0, limit);
      }
    }
    return [];
  }

  Future<List<Comic>> readNewComicsFromDB({required int limit}) async {
    List<Comic> listNewComics = [];
    List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics.isNotEmpty) {
      List<Comic> listNewComicsFilter =
          listComics.where((comic) => comic.add_chapter_time != null).toList();
      if (listNewComicsFilter.isNotEmpty) {
        listNewComicsFilter.sort(
          (comic1, comic2) => (comic2.add_chapter_time!.millisecondsSinceEpoch -
              comic1.add_chapter_time!.millisecondsSinceEpoch),
        );
        for (Comic comic in listNewComicsFilter) {
          listNewComics.add(await readHomeComicCopy(comic));
        }
        limit = limit > listNewComics.length ? listNewComics.length : limit;
        return listNewComics.sublist(0, limit);
      }
    }
    return [];
  }

  // Read Comic detail
  Future<Comic> readComicDetailFromDB({required String id}) async {
    Comic? comic = await HandleDatabase.readComicByIDFromDB(id: id);
    if (comic != null) {
      return await readComicCopy(comic);
    } else {
      return AppConstant.comicNotExist;
    }
  }

  // Read Comic filter
  Future<Comic> readComicFilter({required String id}) async {
    Comic? comic = await HandleDatabase.readComicByIDFromDB(id: id);
    if (comic != null) {
      return await readHomeComicCopy(comic);
    } else {
      return AppConstant.comicNotExist;
    }
  }

  // Read comic by category
  Future<List<Comic>> readComicByCategoryIDFromDB({required String id}) async {
    List<Comic> listComics = [];
    List<CategoriesComics> listComicsReadByCategoryID =
        await HandleDatabase.readCategoriesComicByCategoryID(id: id);
    if (listComicsReadByCategoryID.isNotEmpty) {
      for (var i = 0; i < listComicsReadByCategoryID.length; i++) {
        listComics.add(
            await readComicFilter(id: listComicsReadByCategoryID[i].comic_id));
      }
    }
    return listComics;
  }

// searchComicFromSever
  Future<List<Comic>> searchComic(String query) async {
    String url = "${AppConstant.comicUrl}${AppConstant.search}$query";
    List<Comic> listComicsSearchResult = [];
    try {
      final response = await _apiClient.getData(url);

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final listComics =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          final listComicSearch = listComics
              .where((Comic comic) => comic.title!
                  .toLowerCase()
                  .contains(comic.title!.toLowerCase()))
              .toList();
          if (listComicSearch.isNotEmpty) {
            for (Comic comic in listComicSearch) {
              listComicsSearchResult.add(comic);
            }
          }
          return listComicsSearchResult;
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      print('${e.toString()} sai o comicrepo');
    }
    return [];
  }

  Future<List<Comic>> searchComicByTitle(String title) async {
    List<Comic> listComicsSearchResult = [];
    if (title != '') {
      List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
      if (listComics.isNotEmpty) {
        final listComicsSearch = listComics
            .where((Comic comic) =>
                comic.title!.toLowerCase().startsWith(title.toLowerCase()))
            .toList();
        if (listComicsSearch.isNotEmpty) {
          for (Comic comic in listComicsSearch) {
            listComicsSearchResult.add(await readHomeComicCopy(comic));
          }
          return listComicsSearchResult;
        }
      }
      throw Exception();
    }
    return [];
  }

  // Comic copy
  Future<Comic> readHomeComicCopy(Comic comic) async {
    Image? imageThumnailSquare = (await HandleDatabase.readImageFromDB(
        type: AppConstant.typeImageComic[1], parentID: comic.id));
    Image? imageThumnailRectangle = (await HandleDatabase.readImageFromDB(
        type: AppConstant.typeImageComic[2], parentID: comic.id));
    return Comic.copyWith(
      comic,
      imageThumnailSquare: imageThumnailSquare,
      imageThumnailRectangle: imageThumnailRectangle,
    );
  }

  Future<Comic> readComicCopy(Comic comic) async {
    final List<String> listCategories = [];
    List<CategoriesComics> categoriesComic =
        await HandleDatabase.readAllCategoriesComicsFromDB(comicID: comic.id);
    if (categoriesComic.isNotEmpty) {
      for (var i = 0; i < categoriesComic.length; i++) {
        Category? category = await HandleDatabase.readCategoryByIDFromDB(
            id: categoriesComic[i].category_id);
        if (category != null) {
          listCategories.add(category.name);
        }
      }
    }
    List<Chapter> chapters =
        await HandleDatabase.readChapterByComicIDFromDB(comicID: comic.id);
    if (chapters.isNotEmpty) {
      chapters.sort(
          (chapter1, chapter2) => chapter1.numerical! - chapter2.numerical!);
    }
    Image? imageDetail = (await HandleDatabase.readImageFromDB(
        type: AppConstant.typeImageComic[0], parentID: comic.id));
    Image? imageThumnailSquare = (await HandleDatabase.readImageFromDB(
        type: AppConstant.typeImageComic[1], parentID: comic.id));

    return Comic.copyWith(
      comic,
      imageDetail: imageDetail,
      imageThumnailSquare: imageThumnailSquare,
      listChapters: chapters,
      listCategories: listCategories,
    );
  }

  // Case comic
  Future<void> addCaseComic({
    required String comicId,
    required String chapterId,
    String? imageThumnailSquareComicPath,
    String? titleComic,
    required int numericChapter,
    int? reads,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    List<CaseComic> listCaseComic =
        await getListCaseComicFromLocal(sharedPreferences);
    CaseComic caseComic = CaseComic(
      comicId: comicId,
      chapterId: chapterId,
      imageThumnailSquareComicPath: imageThumnailSquareComicPath,
      titleComic: titleComic,
      numericChapter: numericChapter,
      reads: reads,
    );
    await filterCaseComicByComicID(
      caseComic: caseComic,
      listCaseComic: listCaseComic,
      sharedPreferences: sharedPreferences,
    );
    print("add case comic");
  }

  Future<void> filterCaseComicByComicID({
    required CaseComic caseComic,
    required List<CaseComic> listCaseComic,
    required SharedPreferences sharedPreferences,
  }) async {
    List<CaseComic> listCaseComicFilter = [];
    List<String> listCaseComicToString = [];
    if (listCaseComic.isNotEmpty) {
      listCaseComicFilter = listCaseComic
          .where((caseComicElement) =>
              caseComic.comicId != caseComicElement.comicId)
          .toList();
      listCaseComicFilter.add(caseComic);
    } else {
      listCaseComicFilter.add(caseComic);
    }
    for (var caseComic in listCaseComicFilter) {
      listCaseComicToString.add(jsonEncode(caseComic));
    }
    await sharedPreferences.setStringList(
        AppConstant.listCaseComics, listCaseComicToString);
  }

  Future<List<CaseComic>> getListCaseComicFromLocal(
      SharedPreferences sharedPreferences) async {
    List<CaseComic> listCaseComics = [];
    if (sharedPreferences.containsKey(AppConstant.listCaseComics)) {
      List<String>? listCaseComicFromLocal =
          sharedPreferences.getStringList(AppConstant.listCaseComics);
      for (var caseComicJson in listCaseComicFromLocal!) {
        listCaseComics.add(
          CaseComic.fromJson(
            jsonDecode(caseComicJson),
          ),
        );
      }
    }
    return listCaseComics;
  }

  Future<CaseComic> getCaseComicFromLocal(String comicId) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    List<CaseComic> listCaseComic =
        await getListCaseComicFromLocal(sharedPreferences);
    return listCaseComic.singleWhere(
      (caseComic) => caseComic.comicId == comicId,
      orElse: () => AppConstant.caseComicNotExist,
    );
  }

  // set time ads
  Future<void> setTimesAds(int? timesAds) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(AppConstant.timeAdsLocal)) {
      final timesAdsLocal = sharedPreferences.getInt(AppConstant.timeAdsLocal);
      if (timesAds != null && timesAds != timesAdsLocal) {
        sharedPreferences.setInt(AppConstant.timeAdsLocal, timesAds);
        print("repaired times ads to local ");
      } else {
        print("times ads is the same");
      }
    } else if (timesAds != null) {
      sharedPreferences.setInt(AppConstant.timeAdsLocal, timesAds);
      print("set times ads to local");
    }
  }
}
