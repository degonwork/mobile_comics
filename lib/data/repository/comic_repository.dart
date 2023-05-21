import 'dart:convert';
import '../../config/app_constant.dart';
import '../../data/providers/database/handle_database.dart';
import '../../data/repository/categories_comics_repository.dart';
import '../../data/repository/chapter_repository.dart';
import '../../data/repository/image_repository.dart';
import '../models/comic_model.dart';
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
  Future<List<Comic>> fetchAPIAndCreateDBHotComics({required int limit}) async {
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.HOTCOMICURL}?limit=$limit');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final listHotComicApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          await createComicToDB(listHomeComic: listHotComicApi);

          List<Comic> listHotComics =
              await readHotComicsFromDB(limit: AppConstant.LIMITHOMECOMIC);
          return listHotComics;
        } else {
          print("Hot comic is not available");
          throw Exception("Not Found Data");
        }
      } else {
        print("load failed");
        throw Exception('Load failed');
      }
    } catch (e) {
      print("------------" + e.toString());
    }
    return [];
  }

  Future<List<Comic>> fetchAPIAndCreateDBNewComics({required int limit}) async {
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.NEWCOMICURL}?limit=$limit');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final listNewComicsApi =
              jsonResponse.map((e) => Comic.fromJson(e)).toList();
          await createComicToDB(listHomeComic: listNewComicsApi);
          List<Comic> listNewComics =
              await readNewComicsFromDB(limit: AppConstant.LIMITHOMECOMIC);
          return listNewComics;
        } else {
          print("New comic is not available");
          throw Exception("Not Found Data");
        }
      } else {
        throw Exception('Load failed');
      }
    } catch (e) {
      print("------------" + e.toString());
    }
    return [];
  }

  Future<Comic> fetchDetailComics({required String id}) async {
    try {
      final response = await _apiClient.getData('$_comicUrl$id');
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          final comicApi = Comic.fromJson(jsonResponse);
          await updateComicToDB(comic: comicApi);
          Comic? comic =
              await HandleDatabase.readComicByIDFromDB(id: comicApi.id);
          if (comic != null) {
            return Comic.copyWith(comic);
          }
        } else {
          print("comic is not available");
          throw Exception("Not Found Data");
        }
      } else {
        throw Exception('Load failed');
      }
    } catch (e) {
      // print(e.toString());
    }
    return AppConstant.COMICNOTEXIST;
  }

  // Process Database
  // Create
  Future<void> createComicToDB({required List<Comic> listHomeComic}) async {
    await _imageRepo.createImageComicToDB(listHomeComic: listHomeComic);
    List<Comic> listComics = [];
    for (var homeComic in listHomeComic) {
      String? imageDetailId = await _imageRepo.readIDImageFromDB(
        parentId: homeComic.id,
        typeImage: AppConstant.TYPEIMAGECOMICS[0],
      );
      String? imageThumnailSquareId = await _imageRepo.readIDImageFromDB(
        parentId: homeComic.id,
        typeImage: AppConstant.TYPEIMAGECOMICS[1],
      );
      String? imageThumnailRectangleId = await _imageRepo.readIDImageFromDB(
        parentId: homeComic.id,
        typeImage: AppConstant.TYPEIMAGECOMICS[2],
      );
      Comic comic = Comic(
        id: homeComic.id,
        title: homeComic.title,
        image_detail_id: imageDetailId,
        image_thumnail_square_id: imageThumnailSquareId,
        image_thumnail_rectangle_id: imageThumnailRectangleId,
        add_chapter_time: homeComic.add_chapter_time,
        reads: homeComic.reads,
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
        typeImage: AppConstant.TYPEIMAGECOMICS[0],
        parent: comic,
      );

      String? imageThumnailSquareId = await _imageRepo.createOrUpdateImage(
        imageID: comicDB.image_thumnail_square_id,
        imagePath: comic.image_thumnail_square_path,
        parentDB: comicDB,
        typeImage: AppConstant.TYPEIMAGECOMICS[1],
        parent: comic,
      );

      String? imageThumnailRectangleId = await _imageRepo.createOrUpdateImage(
        imageID: comicDB.image_thumnail_rectangle_id,
        imagePath: comic.image_thumnail_rectangle_path,
        parentDB: comicDB,
        typeImage: AppConstant.TYPEIMAGECOMICS[2],
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
      List<Comic> listComicsFilter =
          listComics.where((comic) => comic.reads != null).toList();
      if (listComicsFilter.isNotEmpty) {
        listComicsFilter
            .sort((comic1, comic2) => (comic2.reads! - comic1.reads!));
        for (Comic comic in listComicsFilter) {
          listHotComics.addAll([await Comic.copyWith(comic)]);
        }
        limit = limit > listHotComics.length ? listHotComics.length : limit;
        return listHotComics.sublist(0, limit);
      }
    }
    return listHotComics;
  }

  Future<List<Comic>> readNewComicsFromDB({required int limit}) async {
    List<Comic> listNewComics = [];
    List<Comic> listComics = await HandleDatabase.readManyComicsFromDB();
    if (listComics.isNotEmpty) {
      List<Comic> listComicsFilter =
          listComics.where((comic) => comic.add_chapter_time != null).toList();
      if (listComicsFilter.isNotEmpty) {
        listComicsFilter.sort(
          (comic1, comic2) => (comic2.add_chapter_time!.millisecondsSinceEpoch -
              comic1.add_chapter_time!.millisecondsSinceEpoch),
        );
        for (Comic comic in listComicsFilter) {
          listNewComics.addAll([await Comic.copyWith(comic)]);
        }
        limit = limit > listNewComics.length ? listNewComics.length : limit;
        return listNewComics.sublist(0, limit);
      }
    }
    return listNewComics;
  }
}
