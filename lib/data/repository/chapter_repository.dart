// import 'dart:convert';
// import 'package:http/http.dart';

import '.././models/comic_model.dart';
import '.././providers/api/api_client.dart';
import '../../config/app_constant.dart';
import '.././repository/image_repository.dart';
import '../models/chapter_model.dart';
import '../models/image_model.dart';
import '../providers/database/handle_database.dart';

class ChapterRepo {
  final ImageRepo _imageRepo;
  final String _chapterUrl;
  final ApiClient _apiClient;
  ChapterRepo({
    required ImageRepo imageRepo,
    required String chapterUrl,
    required ApiClient apiClient,
  })  : _chapterUrl = chapterUrl,
        _apiClient = apiClient,
        _imageRepo = imageRepo;
  //  Fetch Api
  Future<Chapter?> fetchDetailChapters(
      {required String id, required bool isUpdate}) async {
    Chapter? chapterAPi;
    try {
      // Response response = await _apiClient.getData('$_chapterUrl$id');
      // if (response.statusCode == 200) {
      // dynamic jsonResponse = jsonDecode(response.body);
      //   if (jsonResponse != null) {
      dynamic jsonResponse = {
        "_id": "649576e014e28ac54662f268",
        "comic_id": "649576c714e28ac54662f254",
        "image_thumnail": {
          "id": "649576e014e28ac54662f25e",
          "path":
              "http://117.4.194.207:3000/image/298acc78f434e7e164d373a7c68f735e.jpg"
        },
        "content": [
          {
            "id": "649576e014e28ac54662f260",
            "path":
                "http://117.4.194.207:3000/image/6ac3410a7d8195b5857bf768152b5a781.jpg",
            "height": 710,
            "width": 570
          },
          {
            "id": "649576e014e28ac54662f262",
            "path":
                "http://117.4.194.207:3000/image/81c3e5ef150944350e78f7fda843df10b.jpg",
            "height": 275,
            "width": 183
          },
          {
            "id": "649576e014e28ac54662f264",
            "path":
                "http://117.4.194.207:3000/image/e0898d3b1059f210575714a91fdb5a7d09.jpg",
            "height": 285,
            "width": 177
          },
          {
            "id": "649576e014e28ac54662f266",
            "path":
                "http://117.4.194.207:3000/image/6100c63cfe504506eabf44283dfae815b.jpg",
            "height": 1500,
            "width": 880
          }
        ],
        "chapter_des": "Chapter 1",
        "publish_date": 1687516896000,
        "content_update_time": 1687916896002,
        "update_time": 1687926907001
      };
      chapterAPi = Chapter.fromJson(jsonResponse);
      if (isUpdate) {
        Chapter? chapterDB =
            await HandleDatabase.readChapterByIDFromDB(id: chapterAPi.id);
        if (chapterDB != null) {
          if (chapterDB.isFull == 0) {
            await updateChapterDetail(
              chapter: chapterAPi,
              isFullChapter: false,
              chapterDB: chapterDB,
            );
          } else {
            await updateChapterDetail(
                chapter: chapterAPi, isFullChapter: true, chapterDB: chapterDB);
          }
        }
      }
      // } else {
      //   print("chapter is not available");
      // }
      // } else {}
    } catch (e) {
      print(e.toString());
    }
    return chapterAPi;
  }

  // process database
  Future<void> createChapterToDB({required Comic comic}) async {
    if (comic.chapters!.isNotEmpty) {
      await _imageRepo.createImageThumnailChapterToDB(
          listChapters: comic.chapters!);
      List<Chapter> listChapters = [];
      for (int i = 0; i < comic.chapters!.length; i++) {
        String? imageThumnailID = await _imageRepo.readIDImageFromDB(
          parentId: comic.chapters![i].id,
          typeImage: AppConstant.typeImageThumnailChapter,
        );
        listChapters.add(
          Chapter(
            id: comic.chapters![i].id,
            comic_id: comic.id,
            image_thumnail_id: imageThumnailID,
            chapter_des: comic.chapters![i].chapter_des,
            numerical: i + 1,
            isFull: comic.chapters![i].isFull,
          ),
        );
      }
      await HandleDatabase.createChapterToDB(chapters: listChapters);
    } else {
      print("Comic has not Chapters");
    }
  }

  Future<Chapter> readChapterByIdFromDB({required String chapterId}) async {
    Chapter? chapter =
        await HandleDatabase.readChapterByIDFromDB(id: chapterId);
    if (chapter != null) {
      return chapter;
    } else {
      return AppConstant.ChapterNotExist;
    }
  }

  Future<void> updateChapterComicDetail({
    required Comic comic,
    required bool isFullComic,
    required Comic comicDB,
  }) async {
    if (isFullComic &&
        comic.chapter_update_time != comicDB.chapter_update_time) {
      print(
          "Comic ${comic.id} chapter update time change ---------------------------");
      if (comic.chapters!.isNotEmpty) {
        for (Chapter chapter in comic.chapters!) {
          Chapter? chapterDB =
              await HandleDatabase.readChapterByIDFromDB(id: chapter.id);
          if (chapterDB != null) {
            String? imageThumnailId = await _imageRepo.createOrUpdateImage(
              imageID: chapterDB.image_thumnail_id,
              imagePath: chapter.image_thumnail_path,
              parentDB: chapterDB,
              typeImage: AppConstant.typeImageThumnailChapter,
              parent: chapter,
            );
            Chapter updateChapter = Chapter(
              id: chapter.id,
              comic_id: chapter.comic_id ?? chapterDB.comic_id,
              image_thumnail_id: imageThumnailId,
              chapter_des: chapter.chapter_des ?? chapterDB.chapter_des,
              numerical: chapterDB.numerical,
              content_update_time: chapterDB.content_update_time,
              update_time: chapterDB.update_time,
              isFull: chapterDB.isFull,
            );
            print(
                "chapter isFull ${updateChapter.isFull} ------------------------");
            await HandleDatabase.updateChapterToDB(chapter: updateChapter);
            print(
                "update chapter in comic detail ----------------------------------");
            Comic updateComic = Comic(
              id: comic.id,
              image_detail_id: comicDB.image_detail_id,
              image_thumnail_rectangle_id: comicDB.image_thumnail_rectangle_id,
              image_thumnail_square_id: comicDB.image_thumnail_square_id,
              title: comicDB.title,
              author: comicDB.author,
              description: comicDB.description,
              year: comicDB.year,
              reads: comicDB.reads,
              chapter_update_time:
                  comic.chapter_update_time ?? comicDB.chapter_update_time,
              add_chapter_time: comicDB.add_chapter_time,
              update_time: comicDB.update_time,
              isFull: isFullComic ? 1 : 0,
            );
            await HandleDatabase.updateComicToDB(comic: updateComic);
            print(
                "Comic update when chapter update time change -------------------------------");
          }
        }
      }
    }
  }

  Future<void> updateChapterDetail({
    required Chapter chapter,
    required bool isFullChapter,
    required Chapter chapterDB,
  }) async {
    if (!isFullChapter) {
      print("chapter is not full--------------------------------");
      await _imageRepo.createImageChapterContentToDB(chapter: chapter);
      String? imageThumnailId = await _imageRepo.createOrUpdateImage(
        imageID: chapterDB.image_thumnail_id,
        imagePath: chapter.image_thumnail_path,
        parentDB: chapterDB,
        typeImage: AppConstant.typeImageThumnailChapter,
        parent: chapter,
      );
      Chapter updateChapter = Chapter(
        id: chapter.id,
        comic_id: chapter.comic_id ?? chapterDB.comic_id,
        image_thumnail_id: imageThumnailId,
        chapter_des: chapter.chapter_des ?? chapterDB.chapter_des,
        numerical: chapterDB.numerical,
        content_update_time:
            chapter.content_update_time ?? chapterDB.content_update_time,
        update_time: chapter.update_time ?? chapterDB.update_time,
        isFull: 1,
      );
      await HandleDatabase.updateChapterToDB(chapter: updateChapter);
    } else {
      print(
          "Chapter is full in chapter repo----------------------------------------");
      if (chapter.content_update_time != chapterDB.content_update_time) {
        print("Chapter content is change -----------------------------");
        await updateChapterContent(chapter: chapter);
        Chapter updateChapter = Chapter(
          id: chapter.id,
          comic_id: chapter.comic_id ?? chapterDB.comic_id,
          image_thumnail_id: chapterDB.image_thumnail_id,
          chapter_des: chapterDB.chapter_des,
          numerical: chapterDB.numerical,
          content_update_time:
              chapter.content_update_time ?? chapterDB.content_update_time,
          update_time: chapterDB.update_time,
          isFull: 1,
        );
        await HandleDatabase.updateChapterToDB(chapter: updateChapter);
        print(
            "update content and update chapter ------------------------------------");
      }
      if (chapter.update_time != chapterDB.update_time) {
        print("Chapter update time is change -----------------------------");
        String? imageThumnailId = await _imageRepo.createOrUpdateImage(
          imageID: chapterDB.image_thumnail_id,
          imagePath: chapter.image_thumnail_path,
          parentDB: chapterDB,
          typeImage: AppConstant.typeImageThumnailChapter,
          parent: chapter,
        );
        Chapter updateChapter = Chapter(
          id: chapter.id,
          comic_id: chapter.comic_id ?? chapterDB.comic_id,
          image_thumnail_id: imageThumnailId,
          chapter_des: chapter.chapter_des ?? chapterDB.chapter_des,
          numerical: chapterDB.numerical,
          content_update_time:
              chapter.content_update_time ?? chapterDB.content_update_time,
          update_time: chapter.update_time ?? chapterDB.update_time,
          isFull: 1,
        );
        await HandleDatabase.updateChapterToDB(chapter: updateChapter);
        print(
            "update chapter with update time change---------------------------");
      }
    }
  }

  Future<void> updateChapterContent({required Chapter chapter}) async {
    List<Image> imageChapterContents =
        await _imageRepo.readImageChapterContent(chapterId: chapter.id);
    if (imageChapterContents.isNotEmpty) {
      await _imageRepo.deleteImageChapterContent(chapter: chapter);
      print("deleted content");
    }
    await _imageRepo.createImageChapterContentToDB(chapter: chapter);
    print("Repaired content");
  }

  Future<List<Image>> readChapterContentFromDB(
      {required String chapterId}) async {
    List<Image> images = [];
    List<Image> imageChapterContent =
        await _imageRepo.readImageChapterContent(chapterId: chapterId);
    if (imageChapterContent.isNotEmpty) {
      imageChapterContent.sort(
        (imageChapterContent1, imageChapterContent2) =>
            imageChapterContent1.numerical! - imageChapterContent2.numerical!,
      );
      for (var i = 0; i < imageChapterContent.length; i++) {
        Image image = Image(
          id: imageChapterContent[i].id,
          path:
              '${AppConstant.baseServerUrl}${AppConstant.imageUrl}${imageChapterContent[i].path}',
          height: imageChapterContent[i].height,
          width: imageChapterContent[i].width,
          type: imageChapterContent[i].type,
          parent_id: imageChapterContent[i].parent_id,
        );
        images.add(image);
      }
    }
    return images;
  }

// dummy
}
