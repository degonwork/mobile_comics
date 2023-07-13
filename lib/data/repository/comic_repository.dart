import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
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
  Future<void> fetchApiHomeComic({required bool isUpdate}) async {
    List<Comic> listHomeComics = [];
    List<Comic> listHotComics = [];
    List<Comic> listNewComics = [];
    try {
      listHotComics =
          await fetchAPIHotComics(limit: AppConstant.limitHomeComic);
    } catch (e) {
      //  Not found Hot comics
    }
    listHomeComics.addAll(listHotComics);
    try {
      listNewComics =
          await fetchAPINewComics(limit: AppConstant.limitSeeMoreComic);
    } catch (e) {
      //  Not found New comics
    }
    listHomeComics.addAll(listNewComics);
    if (listHomeComics.isNotEmpty) {
      await createComicToDB(listComics: listHomeComics);
      if (isUpdate) {
        for (int i = 0; i < listHomeComics.length; i++) {
          Comic? comicDB = await HandleDatabase.readComicByIDFromDB(
              id: listHomeComics[i].id);
          if (comicDB != null) {
            await updateHomeComic(
              comic: listHomeComics[i],
              comicDB: comicDB,
              isFullComic: comicDB.isFull == 0 ? false : true,
              isDetail: false,
            );
          }
        }
      }
    } else {
      throw Exception("Home comic Not found");
    }
  }

  Future<List<Comic>> fetchAPIHotComics({required int limit}) async {
    List<Comic> listHotComicsApi = [];
    try {
      Response response = await _apiClient
          .getData('$_comicUrl${AppConstant.hotComicUrl}?limit=$limit');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          listHotComicsApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          setTimesAds(listHotComicsApi[0].times_ads);
          return listHotComicsApi;
        }
      }
    } catch (e) {
      //  Not found Hot comics
    }
    return listHotComicsApi;
  }

  Future<List<Comic>> fetchAPINewComics({required int limit}) async {
    List<Comic> listNewComicsApi = [];
    try {
      Response response = await _apiClient
          .getData('$_comicUrl${AppConstant.newComicUrl}?limit=$limit');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          listNewComicsApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          return listNewComicsApi;
        }
      }
    } catch (e) {
      //  Not found New comics
    }
    return listNewComicsApi;
  }

  Future<Comic?> fetchDetailComics(
      {required String id, required bool isUpdate}) async {
    Comic? comicApi;
    try {
      Response response = await _apiClient.getData('$_comicUrl$id');
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          comicApi = Comic.fromJson(jsonResponse);
          if (isUpdate) {
            Comic? comicDB =
                await HandleDatabase.readComicByIDFromDB(id: comicApi.id);
            if (comicDB != null) {
              if (comicDB.isFull == 0) {
                await updateComicDetail(comic: comicApi, comicDB: comicDB);
              } else {
                await updateHomeComic(
                  comic: comicApi,
                  comicDB: comicDB,
                  isFullComic: true,
                  isDetail: true,
                );
              }
            }
          }
          return comicApi;
        }
      }
      throw Exception("Comics not found");
    } catch (e) {
      throw Exception("Comics not found");
    }
  }

  Future<void> fetchAPIAndCreateFilterComicByCategories(
      {required String categoryName, required bool isUpdate}) async {
    List<Comic> listComicFilter = [];
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.category}$categoryName');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          listComicFilter = jsonResponse.map((e) => Comic.fromJson(e)).toList();
          await createComicToDB(listComics: listComicFilter);
          for (var comicFilter in listComicFilter) {
            await _categoriesComicsRepo.processCategoriesComicsToDB(
              comic: comicFilter,
              isUpdateCategoriesComic: false,
              categoryName: categoryName,
            );
          }
          if (isUpdate) {
            for (int i = 0; i < listComicFilter.length; i++) {
              Comic? comicDB = await HandleDatabase.readComicByIDFromDB(
                  id: listComicFilter[i].id);
              if (comicDB != null) {
                await updateHomeComic(
                  comic: listComicFilter[i],
                  comicDB: comicDB,
                  isFullComic: comicDB.isFull == 0 ? false : true,
                  isDetail: false,
                );
              }
            }
          }
        }
      }
    } catch (e) {
      throw Exception("Filter Comics not found");
    }
  }

  // Search Comic
  Future<List<Comic>> searchComic(String query) async {
    String url = "${AppConstant.comicUrl}${AppConstant.search}$query";
    List<Comic> listComicsSearchResult = [];
    if (query != '') {
      try {
        final response = await _apiClient.getData(url);
        if (response.statusCode == 200) {
          List jsonResponse = jsonDecode(response.body);
          if (jsonResponse.isNotEmpty) {
            List<Comic> listComics =
                jsonResponse.map((e) => Comic.fromJson(e)).toList();
            List<Comic> listComicSearch = listComics
                .where(
                  (Comic comic) => comic.title
                      .toLowerCase()
                      .contains(comic.title.toLowerCase()),
                )
                .toList();
            if (listComicSearch.isNotEmpty) {
              for (Comic comic in listComicSearch) {
                listComicsSearchResult.add(comic);
              }
            }
            return listComicsSearchResult;
          }
        }
        throw Exception("Search comics not found");
      } catch (e) {
        throw Exception("Search comics not found");
      }
    }
    return listComicsSearchResult;
  }

  // Process Database
  // Create
  Future<void> createComicToDB({required List<Comic> listComics}) async {
    await _imageRepo.createImageComicToDB(listComics: listComics);
    List<Comic> listComicsCreate = [];
    for (var comic in listComics) {
      String? imageDetailId = await _imageRepo.readIDImageFromDB(
        parentId: comic.id,
        typeImage: AppConstant.typeImageComic[0],
      );
      String? imageThumnailSquareId = await _imageRepo.readIDImageFromDB(
        parentId: comic.id,
        typeImage: AppConstant.typeImageComic[1],
      );
      String? imageThumnailRectangleId = await _imageRepo.readIDImageFromDB(
        parentId: comic.id,
        typeImage: AppConstant.typeImageComic[2],
      );
      Comic comicCreate = Comic(
        id: comic.id,
        title: comic.title,
        image_detail_id: imageDetailId,
        image_thumnail_square_id: imageThumnailSquareId,
        image_thumnail_rectangle_id: imageThumnailRectangleId,
        add_chapter_time: comic.add_chapter_time,
        update_time: comic.update_time,
        reads: comic.reads,
        isFull: comic.isFull,
        author: comic.author,
        chapter_update_time: comic.chapter_update_time,
        description: comic.description,
        year: comic.year,
      );
      listComicsCreate.add(comicCreate);
    }
    await HandleDatabase.createComicToDB(listComics: listComicsCreate);
  }

// Update
  Future<void> updateHomeComic({
    required Comic comic,
    required Comic comicDB,
    required bool isFullComic,
    required bool isDetail,
  }) async {
    if (comic.reads != comicDB.reads ||
        comic.add_chapter_time != comicDB.add_chapter_time) {
      if (isFullComic && comic.add_chapter_time != comicDB.add_chapter_time) {
        try {
          Comic? comicWithAddChapterTimeChange =
              await fetchDetailComics(id: comic.id, isUpdate: false);
          if (comicWithAddChapterTimeChange != null) {
            await _chapterRepo.createChapterToDB(
                comic: comicWithAddChapterTimeChange);
            Comic updateComic = Comic(
              id: comicWithAddChapterTimeChange.id,
              image_detail_id: comicDB.image_detail_id,
              image_thumnail_rectangle_id: comicDB.image_thumnail_rectangle_id,
              image_thumnail_square_id: comicDB.image_thumnail_square_id,
              title: comicWithAddChapterTimeChange.title,
              author: comicWithAddChapterTimeChange.author,
              description: comicWithAddChapterTimeChange.description,
              year: comicWithAddChapterTimeChange.year,
              reads: comicWithAddChapterTimeChange.reads,
              chapter_update_time: comicDB.chapter_update_time,
              add_chapter_time: comicWithAddChapterTimeChange.add_chapter_time,
              update_time: comicDB.update_time,
              isFull: isFullComic ? 1 : 0,
            );
            await HandleDatabase.updateComicToDB(comic: updateComic);
          }
        } catch (e) {
          //  Not found comic
        }
      } else {
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
          chapter_update_time: comicDB.chapter_update_time,
          add_chapter_time: comic.add_chapter_time,
          update_time: comicDB.update_time,
          isFull: isFullComic ? 1 : 0,
        );
        await HandleDatabase.updateComicToDB(comic: updateComic);
      }
    }
    if (comic.update_time != comicDB.update_time) {
      await _categoriesComicsRepo.processCategoriesComicsToDB(
        comic: comic,
        isUpdateCategoriesComic: true,
      );
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
        chapter_update_time: comicDB.chapter_update_time,
        add_chapter_time: comicDB.add_chapter_time,
        update_time: comic.update_time,
        isFull: isFullComic ? 1 : 0,
      );

      await HandleDatabase.updateComicToDB(comic: updateComic);
    }
    if (isDetail) {
      Comic? comicDBUpdated =
          await HandleDatabase.readComicByIDFromDB(id: comic.id);
      if (comicDBUpdated != null) {
        _chapterRepo.updateChapterComicDetail(
            comic: comic, isFullComic: isFullComic, comicDB: comicDBUpdated);
      }
    }
  }

  Future<void> updateComicDetail({
    required Comic comic,
    required Comic comicDB,
  }) async {
    await _categoriesComicsRepo.processCategoriesComicsToDB(
      comic: comic,
      isUpdateCategoriesComic: false,
    );
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
    await _chapterRepo.createChapterToDB(comic: comic);
  }

  // Read Home comic
  Future<List<Comic>> readHotComicsFromDB({required int limit}) async {
    List<Comic> listHotComics = [];
    List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics.isNotEmpty) {
      listComics.sort((comic1, comic2) => (comic2.reads - comic1.reads));
      for (Comic comic in listComics) {
        listHotComics.add(await readHomeComicCopy(comic));
      }
      limit = limit > listHotComics.length ? listHotComics.length : limit;
      return listHotComics.sublist(0, limit);
    }
    return [];
  }

  Future<List<Comic>> readNewComicsFromDB({required int limit}) async {
    List<Comic> listNewComics = [];
    List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics.isNotEmpty) {
      listComics.sort(
        (comic1, comic2) => (comic2.add_chapter_time.millisecondsSinceEpoch -
            comic1.add_chapter_time.millisecondsSinceEpoch),
      );
      for (Comic comic in listComics) {
        listNewComics.add(await readHomeComicCopy(comic));
      }
      limit = limit > listNewComics.length ? listNewComics.length : limit;
      return listNewComics.sublist(0, limit);
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

  // Read Comic By CategoryName
  Future<List<Comic>> readComicByCategoryName(
      {required String categoryName}) async {
    Category? category =
        await HandleDatabase.readCategoryByNameFromDB(name: categoryName);
    if (category != null) {
      return readComicByCategoryIDFromDB(categoryId: category.id);
    }
    return [];
  }

  // Read comic by category
  Future<List<Comic>> readComicByCategoryIDFromDB(
      {required String categoryId}) async {
    List<Comic> listComics = [];
    List<CategoriesComics> listComicsReadByCategoryID =
        await HandleDatabase.readCategoriesComicByCategoryID(
            categoryId: categoryId);
    if (listComicsReadByCategoryID.isNotEmpty) {
      for (var i = 0; i < listComicsReadByCategoryID.length; i++) {
        listComics.add(
            await readComicFilter(id: listComicsReadByCategoryID[i].comic_id));
      }
    }
    return listComics;
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

  Future<List<Comic>> searchComicByTitle(String title) async {
    List<Comic> listComicsSearchResult = [];
    if (title != '') {
      List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
      if (listComics.isNotEmpty) {
        final listComicsSearch = listComics
            .where((Comic comic) =>
                comic.title.toLowerCase().startsWith(title.toLowerCase()))
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
      id: comic.id,
      isFull: comic.isFull,
    );
  }

  Future<Comic> readComicCopy(Comic comic) async {
    List<Chapter> listChaptersFilter = [];
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
      listChaptersFilter =
          chapters.where((chapter) => chapter.chapter_index != null).toList();
      if (listChaptersFilter.isNotEmpty) {
        listChaptersFilter.sort((chapter1, chapter2) =>
            chapter1.chapter_index! - chapter2.chapter_index!);
      }
    }
    Image? imageDetail = (await HandleDatabase.readImageFromDB(
        type: AppConstant.typeImageComic[0], parentID: comic.id));
    Image? imageThumnailSquare = (await HandleDatabase.readImageFromDB(
        type: AppConstant.typeImageComic[1], parentID: comic.id));
    return Comic.copyWith(
      comic,
      imageDetail: imageDetail,
      imageThumnailSquare: imageThumnailSquare,
      listChapters: listChaptersFilter,
      listCategories: listCategories,
      id: comic.id,
      isFull: comic.isFull,
    );
  }

  // Case comic
  Future<void> addCaseComic({
    required String comicId,
    required String chapterId,
    String? imageThumnailSquareComicPath,
    required String titleComic,
    required int numericChapter,
    required int reads,
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
    // print("add case comic");
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
        // print("repaired times ads to local ");
      } else {
        // print("times ads is the same");
      }
    } else if (timesAds != null) {
      sharedPreferences.setInt(AppConstant.timeAdsLocal, timesAds);
      // print("set times ads to local");
    }
  }
}
