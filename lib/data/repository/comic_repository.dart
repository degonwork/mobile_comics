import 'dart:async';
import 'dart:convert';
// import 'package:http/http.dart';
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
    List<Comic> listHotComics =
        await fetchAPIHotComics(limit: AppConstant.limitHomeComic);
    listHomeComics.addAll(listHotComics);
    List<Comic> listNewComics =
        await fetchAPINewComics(limit: AppConstant.limitSeeMoreComic);
    listHomeComics.addAll(listNewComics);
    if (listHomeComics.isNotEmpty) {
      await createComicToDB(listComics: listHomeComics);
      print("Created comic ----------------------");
      if (isUpdate) {
        for (int i = 0; i < listHomeComics.length; i++) {
          Comic? comicDB = await HandleDatabase.readComicByIDFromDB(
              id: listHomeComics[i].id);
          if (comicDB != null) {
            print("required update ---------------------");
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
      print("dont create comic ----------------------");
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
        //
      // List<dynamic> jsonResponse = [
      //   {
      //     "id": "648bfd4cdbf16ad1f464bdbe",
      //     "title": "Thanh gươm diệt quỷ",
      //     "image_detail": {
      //       "id": "648bfd4cdbf16ad1f464bdb5",
      //       "path":
      //           "http://117.4.194.207:3000/image/6ee75f6cbf74118610710bd32e9a478da9.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "648bfd4cdbf16ad1f464bdb7",
      //       "path":
      //           "http://117.4.194.207:3000/image/de51283d1510669b0681853ac10b741acd.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "648bfd4cdbf16ad1f464bdb9",
      //       "path":
      //           "http://117.4.194.207:3000/image/fa46107d3d64eb1a57ce386103ae37eab0.jpg"
      //     },
      //     "reads": 9554,
      //     "categories": ["Hành động", "Phiêu lưu", "Hài hước"],
      //     "add_chapter_time": 1686895995000,
      //     "update_time": 1687536465000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "648bfbaaa35b676fbcb0820b",
      //     "title": "OnePiece",
      //     "image_detail": {
      //       "id": "648bfbaaa35b676fbcb081f9",
      //       "path":
      //           "http://117.4.194.207:3000/image/c43107d4b1a58610a93785374c2129106bc.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "648bfbaaa35b676fbcb081fb",
      //       "path":
      //           "http://117.4.194.207:3000/image/3a5408109834e195f8ef16d310545ce52c.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "648bfbaaa35b676fbcb081fd",
      //       "path":
      //           "http://117.4.194.207:3000/image/957ecf5cfab723fc2cc5e2ded5dad1a8.jpg"
      //     },
      //     "reads": 5963,
      //     "categories": ["Hành động", "Hài hước", "Phiêu lưu", "Fantasy"],
      //     "add_chapter_time": 1687031898000,
      //     "update_time": 1687536439000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "649576c714e28ac54662f254",
      //     "title": "Thế giới mới",
      //     "image_detail": {
      //       "id": "649576c714e28ac54662f24a",
      //       "path":
      //           "http://117.4.194.207:3000/image/fdce1ec913b78fed602ac582262ae8d3.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "649576c714e28ac54662f24c",
      //       "path":
      //           "http://117.4.194.207:3000/image/102106d3cc98cc2ca104a0409e4aa878102f.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "649576c714e28ac54662f24e",
      //       "path":
      //           "http://117.4.194.207:3000/image/8bae1792a3a79c4d3b264875f759eeba.jpg"
      //     },
      //     "reads": 4646,
      //     "categories": ["Hài hước", "Âm nhạc"],
      //     "add_chapter_time": 1687926907000,
      //     "update_time": 1687926907000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "648bfc15a35b676fbcb0828e",
      //     "title": "Solo Eving",
      //     "image_detail": {
      //       "id": "648bfc15a35b676fbcb08283",
      //       "path":
      //           "http://117.4.194.207:3000/image/62ca14e9a10f3ab74e25097610b537e4a7.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "648bfc15a35b676fbcb08285",
      //       "path":
      //           "http://117.4.194.207:3000/image/b6185a9c0b6c75debcecde0c9fe510c23.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "648bfc15a35b676fbcb08287",
      //       "path":
      //           "http://117.4.194.207:3000/image/8bf7bf43260851073c40957525eae3def.jpg"
      //     },
      //     "reads": 4621,
      //     "categories": ["Drama", "Hành động", "Phiêu lưu"],
      //     "add_chapter_time": 1686895683000,
      //     "update_time": 1687786052000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "6499919ee6b500162a51fc3a",
      //     "title": "Anh yêu em",
      //     "image_detail": {
      //       "id": "6499919ee6b500162a51fc30",
      //       "path":
      //           "http://117.4.194.207:3000/image/a4c36f18c1ac9384e66310486e2c37642.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "6499919ee6b500162a51fc32",
      //       "path":
      //           "http://117.4.194.207:3000/image/1e96b3104e746af9d11e6db6d110049185.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "6499919ee6b500162a51fc34",
      //       "path":
      //           "http://117.4.194.207:3000/image/aa45a3575569aa10d364fc65a8219dacf.jpg"
      //     },
      //     "reads": 0,
      //     "categories": ["Hài hước", "Trường học"],
      //     "add_chapter_time": 1687785906000,
      //     "update_time": 1687785906000,
      //     "times_ads": 5
      //   }
      // ];
      listHotComicsApi = jsonResponse.map((e) => Comic.fromJson(e)).toList();
      setTimesAds(listHotComicsApi[0].times_ads);
        } else {
          print("Hot comic is not available");
        }
      } else {
      print("load failed hot comic");
      }
    } catch (e) {
      // print(e.toString() + "------------------------------------------");
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
        //
      // List<dynamic> jsonResponse = [
      //   {
      //     "id": "649576c714e28ac54662f254",
      //     "title": "Thế giới mới",
      //     "image_detail": {
      //       "id": "649576c714e28ac54662f24a",
      //       "path":
      //           "http://117.4.194.207:3000/image/fdce1ec913b78fed602ac582262ae8d3.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "649576c714e28ac54662f24c",
      //       "path":
      //           "http://117.4.194.207:3000/image/102106d3cc98cc2ca104a0409e4aa878102f.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "649576c714e28ac54662f24e",
      //       "path":
      //           "http://117.4.194.207:3000/image/8bae1792a3a79c4d3b264875f759eeba.jpg"
      //     },
      //     "reads": 4646,
      //     "categories": ["Hài hước", "Âm nhạc"],
      //     "add_chapter_time": 1687926907000,
      //     "update_time": 1687926907000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "64999200e6b500162a51fc6d",
      //     "title": "Ngôn ngữ tình yêu",
      //     "image_detail": {
      //       "id": "64999200e6b500162a51fc61",
      //       "path":
      //           "http://117.4.194.207:3000/image/37fae1635de4e254b54de2aaa3f90aa4.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "64999200e6b500162a51fc63",
      //       "path":
      //           "http://117.4.194.207:3000/image/a1bf244b241365df59e2395d10d18a9a3.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "64999200e6b500162a51fc65",
      //       "path":
      //           "http://117.4.194.207:3000/image/c0be3c8f3a866511e56f0d3119282675.jpg"
      //     },
      //     "reads": 0,
      //     "categories": ["Sáng tạo", "Lãng mạn"],
      //     "add_chapter_time": 1687785997000,
      //     "update_time": 1687785997000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "6499919ee6b500162a51fc3a",
      //     "title": "Anh yêu em",
      //     "image_detail": {
      //       "id": "6499919ee6b500162a51fc30",
      //       "path":
      //           "http://117.4.194.207:3000/image/a4c36f18c1ac9384e66310486e2c37642.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "6499919ee6b500162a51fc32",
      //       "path":
      //           "http://117.4.194.207:3000/image/1e96b3104e746af9d11e6db6d110049185.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "6499919ee6b500162a51fc34",
      //       "path":
      //           "http://117.4.194.207:3000/image/aa45a3575569aa10d364fc65a8219dacf.jpg"
      //     },
      //     "reads": 0,
      //     "categories": ["Hài hước", "Trường học"],
      //     "add_chapter_time": 1687785906000,
      //     "update_time": 1687785906000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "648bfbaaa35b676fbcb0820b",
      //     "title": "OnePiece",
      //     "image_detail": {
      //       "id": "648bfbaaa35b676fbcb081f9",
      //       "path":
      //           "http://117.4.194.207:3000/image/c43107d4b1a58610a93785374c2129106bc.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "648bfbaaa35b676fbcb081fb",
      //       "path":
      //           "http://117.4.194.207:3000/image/3a5408109834e195f8ef16d310545ce52c.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "648bfbaaa35b676fbcb081fd",
      //       "path":
      //           "http://117.4.194.207:3000/image/957ecf5cfab723fc2cc5e2ded5dad1a8.jpg"
      //     },
      //     "reads": 5963,
      //     "categories": ["Hành động", "Hài hước", "Phiêu lưu", "Fantasy"],
      //     "add_chapter_time": 1687031898000,
      //     "update_time": 1687536439000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "648bfd4cdbf16ad1f464bdbe",
      //     "title": "Thanh gươm diệt quỷ",
      //     "image_detail": {
      //       "id": "648bfd4cdbf16ad1f464bdb5",
      //       "path":
      //           "http://117.4.194.207:3000/image/6ee75f6cbf74118610710bd32e9a478da9.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "648bfd4cdbf16ad1f464bdb7",
      //       "path":
      //           "http://117.4.194.207:3000/image/de51283d1510669b0681853ac10b741acd.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "648bfd4cdbf16ad1f464bdb9",
      //       "path":
      //           "http://117.4.194.207:3000/image/fa46107d3d64eb1a57ce386103ae37eab0.jpg"
      //     },
      //     "reads": 9554,
      //     "categories": ["Hành động", "Phiêu lưu", "Hài hước"],
      //     "add_chapter_time": 1686895995000,
      //     "update_time": 1687536465000,
      //     "times_ads": 5
      //   },
      //   {
      //     "id": "648bfc15a35b676fbcb0828e",
      //     "title": "Solo Eving",
      //     "image_detail": {
      //       "id": "648bfc15a35b676fbcb08283",
      //       "path":
      //           "http://117.4.194.207:3000/image/62ca14e9a10f3ab74e25097610b537e4a7.jpg"
      //     },
      //     "image_thumnail_square": {
      //       "id": "648bfc15a35b676fbcb08285",
      //       "path":
      //           "http://117.4.194.207:3000/image/b6185a9c0b6c75debcecde0c9fe510c23.jpg"
      //     },
      //     "image_thumnail_rectangle": {
      //       "id": "648bfc15a35b676fbcb08287",
      //       "path":
      //           "http://117.4.194.207:3000/image/8bf7bf43260851073c40957525eae3def.jpg"
      //     },
      //     "reads": 4621,
      //     "categories": ["Drama", "Hành động", "Phiêu lưu"],
      //     "add_chapter_time": 1686895683000,
      //     "update_time": 1687786052000,
      //     "times_ads": 5
      //   }
      // ];
      listNewComicsApi = jsonResponse.map((e) => Comic.fromJson(e)).toList();
        } else {
          print("New comic is not available");
        }
      } else {
        print("load failed new comic");
      }
    } catch (e) {
      // print(e.toString() + "------------------------------------------");
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
      //
    // dynamic jsonResponse = {
    //   "_id": "649576c714e28ac54662f254",
    //   "title": "Thế giới mới",
    //   "categories": ["Hài hước", "Âm nhạc"],
    //   "author": "Dung",
    //   "description":
    //       "Tân Thế giới (tiếng Anh: New World) là một trong những tên gọi được sử dụng cho phần lớn Tây Bán cầu của Trái Đất, đặc biệt là châu Mỹ (bao gồm cả các đảo lân cận nó) và châu Đại Dương. Châu Mỹ khi được phát hiện vào thời điểm thế kỷ 16–17 là hoàn toàn mới lạ đối với người châu Âu, những người trước đó cho rằng thế giới chỉ bao gồm châu Âu, châu Á và châu Phi (hay còn gọi là Cựu thế giới)",
    //   "year": 2020,
    //   "chapters": [
    //     {
    //       "chapter_id": "649576e014e28ac54662f268",
    //       "chapter_des": "Chapter 1",
    //       "image_thumnail": {
    //         "path":
    //             "http://117.4.194.207:3000/image/298acc78f434e7e164d373a7c68f735e.jpg",
    //         "id": "649576e014e28ac54662f25e"
    //       }
    //     },
    //     {
    //       "chapter_id": "649576ef14e28ac54662f27d",
    //       "chapter_des": "Chapter 2",
    //       "image_thumnail": {
    //         "path":
    //             "http://117.4.194.207:3000/image/1ac0be36f126918f95f22110c97989de0.jpg",
    //         "id": "649576ef14e28ac54662f271"
    //       }
    //     },
    //     {
    //       "chapter_id": "649bb87be6b500162a520dc8",
    //       "chapter_des": "Chapter 3",
    //       "image_thumnail": {
    //         "path":
    //             "http://117.4.194.207:3000/image/c7acc10848cabb55d310edd94c9c61f709.jpg",
    //         "id": "649bb87be6b500162a520dc0"
    //       }
    //     }
    //   ],
    //   "reads": 4646,
    //   "image_detail": {
    //     "id": "649576c714e28ac54662f24a",
    //     "path":
    //         "http://117.4.194.207:3000/image/fdce1ec913b78fed602ac582262ae8d3.jpg"
    //   },
    //   "image_thumnail_square": {
    //     "id": "649576c714e28ac54662f24c",
    //     "path":
    //         "http://117.4.194.207:3000/image/102106d3cc98cc2ca104a0409e4aa878102f.jpg"
    //   },
    //   "image_thumnail_rectangle": {
    //     "id": "649576c714e28ac54662f24e",
    //     "path":
    //         "http://117.4.194.207:3000/image/8bae1792a3a79c4d3b264875f759eeba.jpg"
    //   },
    //   "chapter_update_time": null,
    //   "update_time": 1687926907000,
    //   "add_chapter_time": 1687926907000
    // };
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
    } else {
      print("comic is not available");
    }
    } else {
      print("load failed");
    }
    } catch (e) {
      print(e.toString());
    }
    return comicApi;
  }

  Future<void> fetchAPIAndCreateFilterComicByCategories(
      {required String categoryName, required bool isUpdate}) async {
    // List<dynamic> jsonResponse = [];
    List<Comic> listComicFilter = [];
    try {
      final response = await _apiClient
          .getData('$_comicUrl${AppConstant.category}$categoryName');
      if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);

    if (jsonResponse.isNotEmpty) {
      // 
    // switch (categoryName) {
    //   case "Hành động":
    //     jsonResponse = [
    //       {
    //         "id": "648bfd4cdbf16ad1f464bdbe",
    //         "title": "Thanh gươm diệt quỷ",
    //         "image_detail": {
    //           "id": "648bfd4cdbf16ad1f464bdb5",
    //           "path":
    //               "http://117.4.194.207:3000/image/6ee75f6cbf74118610710bd32e9a478da9.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfd4cdbf16ad1f464bdb7",
    //           "path":
    //               "http://117.4.194.207:3000/image/de51283d1510669b0681853ac10b741acd.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfd4cdbf16ad1f464bdb9",
    //           "path":
    //               "http://117.4.194.207:3000/image/fa46107d3d64eb1a57ce386103ae37eab0.jpg"
    //         },
    //         "reads": 9554,
    //         "categories": ["Hành động", "Phiêu lưu", "Hài hước"],
    //         "add_chapter_time": 1686895995000,
    //         "update_time": 1687536465000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "648bfbaaa35b676fbcb0820b",
    //         "title": "OnePiece",
    //         "image_detail": {
    //           "id": "648bfbaaa35b676fbcb081f9",
    //           "path":
    //               "http://117.4.194.207:3000/image/c43107d4b1a58610a93785374c2129106bc.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfbaaa35b676fbcb081fb",
    //           "path":
    //               "http://117.4.194.207:3000/image/3a5408109834e195f8ef16d310545ce52c.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfbaaa35b676fbcb081fd",
    //           "path":
    //               "http://117.4.194.207:3000/image/957ecf5cfab723fc2cc5e2ded5dad1a8.jpg"
    //         },
    //         "reads": 5963,
    //         "categories": ["Hành động", "Hài hước", "Phiêu lưu", "Fantasy"],
    //         "add_chapter_time": 1687031898000,
    //         "update_time": 1687536439000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "648bfc15a35b676fbcb0828e",
    //         "title": "Solo Eving",
    //         "image_detail": {
    //           "id": "648bfc15a35b676fbcb08283",
    //           "path":
    //               "http://117.4.194.207:3000/image/62ca14e9a10f3ab74e25097610b537e4a7.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfc15a35b676fbcb08285",
    //           "path":
    //               "http://117.4.194.207:3000/image/b6185a9c0b6c75debcecde0c9fe510c23.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfc15a35b676fbcb08287",
    //           "path":
    //               "http://117.4.194.207:3000/image/8bf7bf43260851073c40957525eae3def.jpg"
    //         },
    //         "reads": 4621,
    //         "categories": ["Drama", "Hành động", "Phiêu lưu"],
    //         "add_chapter_time": 1686895683000,
    //         "update_time": 1687786052000,
    //         "times_ads": 5
    //       },
    //     ];
    //     break;
    //   case "Hài hước":
    //     jsonResponse = [
    //       {
    //         "id": "648bfd4cdbf16ad1f464bdbe",
    //         "title": "Thanh gươm diệt quỷ",
    //         "image_detail": {
    //           "id": "648bfd4cdbf16ad1f464bdb5",
    //           "path":
    //               "http://117.4.194.207:3000/image/6ee75f6cbf74118610710bd32e9a478da9.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfd4cdbf16ad1f464bdb7",
    //           "path":
    //               "http://117.4.194.207:3000/image/de51283d1510669b0681853ac10b741acd.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfd4cdbf16ad1f464bdb9",
    //           "path":
    //               "http://117.4.194.207:3000/image/fa46107d3d64eb1a57ce386103ae37eab0.jpg"
    //         },
    //         "reads": 9554,
    //         "categories": ["Hành động", "Phiêu lưu", "Hài hước"],
    //         "add_chapter_time": 1686895995000,
    //         "update_time": 1687536465000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "648bfbaaa35b676fbcb0820b",
    //         "title": "OnePiece",
    //         "image_detail": {
    //           "id": "648bfbaaa35b676fbcb081f9",
    //           "path":
    //               "http://117.4.194.207:3000/image/c43107d4b1a58610a93785374c2129106bc.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfbaaa35b676fbcb081fb",
    //           "path":
    //               "http://117.4.194.207:3000/image/3a5408109834e195f8ef16d310545ce52c.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfbaaa35b676fbcb081fd",
    //           "path":
    //               "http://117.4.194.207:3000/image/957ecf5cfab723fc2cc5e2ded5dad1a8.jpg"
    //         },
    //         "reads": 5963,
    //         "categories": ["Hành động", "Hài hước", "Phiêu lưu", "Fantasy"],
    //         "add_chapter_time": 1687031898000,
    //         "update_time": 1687536439000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "649576c714e28ac54662f254",
    //         "title": "Thế giới mới",
    //         "image_detail": {
    //           "id": "649576c714e28ac54662f24a",
    //           "path":
    //               "http://117.4.194.207:3000/image/fdce1ec913b78fed602ac582262ae8d3.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "649576c714e28ac54662f24c",
    //           "path":
    //               "http://117.4.194.207:3000/image/102106d3cc98cc2ca104a0409e4aa878102f.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "649576c714e28ac54662f24e",
    //           "path":
    //               "http://117.4.194.207:3000/image/8bae1792a3a79c4d3b264875f759eeba.jpg"
    //         },
    //         "reads": 4646,
    //         "categories": ["Hài hước", "Âm nhạc"],
    //         "add_chapter_time": 1687926907000,
    //         "update_time": 1687926907000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "6499919ee6b500162a51fc3a",
    //         "title": "Anh yêu em",
    //         "image_detail": {
    //           "id": "6499919ee6b500162a51fc30",
    //           "path":
    //               "http://117.4.194.207:3000/image/a4c36f18c1ac9384e66310486e2c37642.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "6499919ee6b500162a51fc32",
    //           "path":
    //               "http://117.4.194.207:3000/image/1e96b3104e746af9d11e6db6d110049185.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "6499919ee6b500162a51fc34",
    //           "path":
    //               "http://117.4.194.207:3000/image/aa45a3575569aa10d364fc65a8219dacf.jpg"
    //         },
    //         "reads": 0,
    //         "categories": ["Hài hước", "Trường học"],
    //         "add_chapter_time": 1687785906000,
    //         "update_time": 1687785906000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "6499a61ce6b500162a51ff92",
    //         "title": "Http code",
    //         "image_detail": {
    //           "id": "6499a61ce6b500162a51ff8b",
    //           "path":
    //               "http://117.4.194.207:3000/image/beb144d10b9cc6929b0bd6be2e5fc14e7.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "6499a61ce6b500162a51ff8d",
    //           "path":
    //               "http://117.4.194.207:3000/image/35e57bd9a86ab0210be1a627ce3b34b65.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "6499a61ce6b500162a51ff8f",
    //           "path":
    //               "http://117.4.194.207:3000/image/d3c2a4499338d68541083fb4a464acad9.jpg"
    //         },
    //         "reads": 0,
    //         "categories": ["Hài hước"],
    //         "add_chapter_time": null,
    //         "update_time": null,
    //         "times_ads": 5
    //       }
    //     ];
    //     break;
    //   case "Phiêu lưu":
    //     jsonResponse = [
    //       {
    //         "id": "648bfd4cdbf16ad1f464bdbe",
    //         "title": "Thanh gươm diệt quỷ",
    //         "image_detail": {
    //           "id": "648bfd4cdbf16ad1f464bdb5",
    //           "path":
    //               "http://117.4.194.207:3000/image/6ee75f6cbf74118610710bd32e9a478da9.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfd4cdbf16ad1f464bdb7",
    //           "path":
    //               "http://117.4.194.207:3000/image/de51283d1510669b0681853ac10b741acd.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfd4cdbf16ad1f464bdb9",
    //           "path":
    //               "http://117.4.194.207:3000/image/fa46107d3d64eb1a57ce386103ae37eab0.jpg"
    //         },
    //         "reads": 9554,
    //         "categories": ["Hành động", "Phiêu lưu", "Hài hước"],
    //         "add_chapter_time": 1686895995000,
    //         "update_time": 1687536465000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "648bfbaaa35b676fbcb0820b",
    //         "title": "OnePiece",
    //         "image_detail": {
    //           "id": "648bfbaaa35b676fbcb081f9",
    //           "path":
    //               "http://117.4.194.207:3000/image/c43107d4b1a58610a93785374c2129106bc.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfbaaa35b676fbcb081fb",
    //           "path":
    //               "http://117.4.194.207:3000/image/3a5408109834e195f8ef16d310545ce52c.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfbaaa35b676fbcb081fd",
    //           "path":
    //               "http://117.4.194.207:3000/image/957ecf5cfab723fc2cc5e2ded5dad1a8.jpg"
    //         },
    //         "reads": 5963,
    //         "categories": ["Hành động", "Hài hước", "Phiêu lưu", "Fantasy"],
    //         "add_chapter_time": 1687031898000,
    //         "update_time": 1687536439000,
    //         "times_ads": 5
    //       },
    //       {
    //         "id": "648bfc15a35b676fbcb0828e",
    //         "title": "Solo Eving",
    //         "image_detail": {
    //           "id": "648bfc15a35b676fbcb08283",
    //           "path":
    //               "http://117.4.194.207:3000/image/62ca14e9a10f3ab74e25097610b537e4a7.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "648bfc15a35b676fbcb08285",
    //           "path":
    //               "http://117.4.194.207:3000/image/b6185a9c0b6c75debcecde0c9fe510c23.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "648bfc15a35b676fbcb08287",
    //           "path":
    //               "http://117.4.194.207:3000/image/8bf7bf43260851073c40957525eae3def.jpg"
    //         },
    //         "reads": 4621,
    //         "categories": ["Drama", "Hành động", "Phiêu lưu"],
    //         "add_chapter_time": 1686895683000,
    //         "update_time": 1687786052000,
    //         "times_ads": 5
    //       },
    //     ];
    //     break;
    //   case "Âm nhạc":
    //     jsonResponse = [
    //       {
    //         "id": "649576c714e28ac54662f254",
    //         "title": "Thế giới mới",
    //         "image_detail": {
    //           "id": "649576c714e28ac54662f24a",
    //           "path":
    //               "http://117.4.194.207:3000/image/fdce1ec913b78fed602ac582262ae8d3.jpg"
    //         },
    //         "image_thumnail_square": {
    //           "id": "649576c714e28ac54662f24c",
    //           "path":
    //               "http://117.4.194.207:3000/image/102106d3cc98cc2ca104a0409e4aa878102f.jpg"
    //         },
    //         "image_thumnail_rectangle": {
    //           "id": "649576c714e28ac54662f24e",
    //           "path":
    //               "http://117.4.194.207:3000/image/8bae1792a3a79c4d3b264875f759eeba.jpg"
    //         },
    //         "reads": 4646,
    //         "categories": ["Hài hước", "Âm nhạc"],
    //         "add_chapter_time": 1687926907000,
    //         "update_time": 1687926907000,
    //         "times_ads": 5
    //       }
    //     ];
    //     break;
    // }
    listComicFilter = jsonResponse.map((e) => Comic.fromJson(e)).toList();
    await createComicToDB(listComics: listComicFilter);
    for (var comicFilter in listComicFilter) {
      await _categoriesComicsRepo.processCategoriesComicsToDB(
        comic: comicFilter,
        isUpdateCategoriesComic: false,
      );
    }
    if (isUpdate) {
      for (int i = 0; i < listComicFilter.length; i++) {
        Comic? comicDB =
            await HandleDatabase.readComicByIDFromDB(id: listComicFilter[i].id);
        if (comicDB != null) {
          print("required update ---------------------");
          await updateHomeComic(
            comic: listComicFilter[i],
            comicDB: comicDB,
            isFullComic: comicDB.isFull == 0 ? false : true,
            isDetail: false,
          );
        }
      }
    }
    } else {
      print("Comic filter is not available");
    }
    } else {}
    } catch (e) {
      // print(e.toString());
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
          throw Exception();
        }
      } catch (e) {
        throw Exception();
        // print('${e.toString()} sai o comicrepo');
      }
      // return [];
    }
    return [];
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
      print(
          "${comic.id} reads or add chapter time change ----------------------------");
      if (isFullComic && comic.add_chapter_time != comicDB.add_chapter_time) {
        print(
            "${comic.id} comic is full add chapter time change ----------------------------");
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
            title: comicWithAddChapterTimeChange.title ?? comicDB.title,
            author: comicWithAddChapterTimeChange.author ?? comicDB.author,
            description: comicWithAddChapterTimeChange.description ??
                comicDB.description,
            year: comicWithAddChapterTimeChange.year ?? comicDB.year,
            reads: comicWithAddChapterTimeChange.reads ?? comicDB.reads,
            chapter_update_time: comicDB.chapter_update_time,
            add_chapter_time: comicWithAddChapterTimeChange.add_chapter_time ??
                comicDB.add_chapter_time,
            update_time: comicDB.update_time,
            isFull: isFullComic ? 1 : 0,
          );
          await HandleDatabase.updateComicToDB(comic: updateComic);
        }
      } else {
        print(
            "${comic.id} comic is not full or full and add chapter time change or reads change");
        Comic updateComic = Comic(
          id: comic.id,
          image_detail_id: comicDB.image_detail_id,
          image_thumnail_rectangle_id: comicDB.image_thumnail_rectangle_id,
          image_thumnail_square_id: comicDB.image_thumnail_square_id,
          title: comic.title ?? comicDB.title,
          author: comic.author ?? comicDB.author,
          description: comic.description ?? comicDB.description,
          year: comic.year ?? comicDB.year,
          reads: comic.reads ?? comicDB.reads,
          chapter_update_time: comicDB.chapter_update_time,
          add_chapter_time: comic.add_chapter_time ?? comicDB.add_chapter_time,
          update_time: comicDB.update_time,
          isFull: isFullComic ? 1 : 0,
        );
        await HandleDatabase.updateComicToDB(comic: updateComic);
      }
      print("Comic ${comic.id} updated reads or add_chapter_time");
    }
    if (comic.update_time != comicDB.update_time) {
      print(
          "Update time comic ${comic.id} is change -------------------------");
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
        title: comic.title ?? comicDB.title,
        author: comic.author ?? comicDB.author,
        description: comic.description ?? comicDB.description,
        year: comic.year ?? comicDB.year,
        reads: comic.reads ?? comicDB.reads,
        chapter_update_time: comicDB.chapter_update_time,
        add_chapter_time: comicDB.add_chapter_time,
        update_time: comic.update_time ?? comicDB.update_time,
        isFull: isFullComic ? 1 : 0,
      );
      
      await HandleDatabase.updateComicToDB(comic: updateComic);
      print("Comic ${comic.id} updated full");
    }
    if (isDetail) {
      print("this is comic ${comic.id} detail");
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
      title: comic.title ?? comicDB.title,
      author: comic.author ?? comicDB.author,
      description: comic.description ?? comicDB.description,
      year: comic.year ?? comicDB.year,
      reads: comic.reads ?? comicDB.reads,
      chapter_update_time:
          comic.chapter_update_time ?? comicDB.chapter_update_time,
      add_chapter_time: comic.add_chapter_time ?? comicDB.add_chapter_time,
      update_time: comic.update_time ?? comicDB.update_time,
      isFull: 1,
    );
    await HandleDatabase.updateComicToDB(comic: updateComic);
    print("Comic ${comic.id} detail updated with is not full");
    await _chapterRepo.createChapterToDB(comic: comic);
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
          (chapter1, chapter2) => chapter1.chapter_index! - chapter2.chapter_index!);
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
