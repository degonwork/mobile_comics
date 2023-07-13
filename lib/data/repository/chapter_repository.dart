import 'dart:convert';
import 'package:http/http.dart';
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
  Future<void> fetchDetailChapters({required String id}) async {
    Chapter? chapterAPi;
    try {
      Response response = await _apiClient.getData('$_chapterUrl$id');
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          chapterAPi = Chapter.fromJson(jsonResponse);
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
                  chapter: chapterAPi,
                  isFullChapter: true,
                  chapterDB: chapterDB);
            }
          }
        }
      }
    } catch (e) {
      throw Exception("Chapter not found");
    }
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
            chapter_index: comic.chapters![i].chapter_index ?? i + 1,
            isFull: comic.chapters![i].isFull,
            content_update_time: comic.chapters![i].content_update_time,
            publish_date: comic.chapters![i].publish_date,
            update_time: comic.chapters![i].update_time,
          ),
        );
      }
      await HandleDatabase.createChapterToDB(chapters: listChapters);
    }
  }

  Future<Chapter?> readChapterByIdFromDB({required String chapterId}) async {
    Chapter? chapter =
        await HandleDatabase.readChapterByIDFromDB(id: chapterId);
    if (chapter != null) {
      return chapter;
    }
    return null;
  }

  Future<void> updateChapterComicDetail({
    required Comic comic,
    required bool isFullComic,
    required Comic comicDB,
  }) async {
    if (isFullComic &&
        comic.chapter_update_time != comicDB.chapter_update_time) {
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
              comic_id: chapter.comic_id,
              image_thumnail_id: imageThumnailId,
              chapter_des: chapter.chapter_des,
              chapter_index: chapterDB.chapter_index,
              content_update_time: chapterDB.content_update_time,
              update_time: chapterDB.update_time,
              isFull: chapterDB.isFull,
              publish_date: chapterDB.publish_date,
            );
            await HandleDatabase.updateChapterToDB(chapter: updateChapter);
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
              chapter_update_time: comic.chapter_update_time,
              add_chapter_time: comicDB.add_chapter_time,
              update_time: comicDB.update_time,
              isFull: isFullComic ? 1 : 0,
            );
            await HandleDatabase.updateComicToDB(comic: updateComic);
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
        comic_id: chapter.comic_id,
        image_thumnail_id: imageThumnailId,
        chapter_des: chapter.chapter_des,
        chapter_index: chapterDB.chapter_index,
        content_update_time: chapter.content_update_time,
        update_time: chapter.update_time,
        publish_date: chapter.publish_date,
        isFull: 1,
      );
      await HandleDatabase.updateChapterToDB(chapter: updateChapter);
    } else {
      if (chapter.content_update_time != chapterDB.content_update_time) {
        await updateChapterContent(chapter: chapter);
        Chapter updateChapter = Chapter(
          id: chapter.id,
          comic_id: chapter.comic_id,
          image_thumnail_id: chapterDB.image_thumnail_id,
          chapter_des: chapterDB.chapter_des,
          chapter_index: chapterDB.chapter_index,
          content_update_time: chapter.content_update_time,
          update_time: chapterDB.update_time,
          publish_date: chapterDB.publish_date,
          isFull: 1,
        );
        await HandleDatabase.updateChapterToDB(chapter: updateChapter);
      }
      if (chapter.update_time != chapterDB.update_time) {
        String? imageThumnailId = await _imageRepo.createOrUpdateImage(
          imageID: chapterDB.image_thumnail_id,
          imagePath: chapter.image_thumnail_path,
          parentDB: chapterDB,
          typeImage: AppConstant.typeImageThumnailChapter,
          parent: chapter,
        );
        Chapter updateChapter = Chapter(
          id: chapter.id,
          comic_id: chapter.comic_id,
          image_thumnail_id: imageThumnailId,
          chapter_des: chapter.chapter_des,
          chapter_index: chapterDB.chapter_index,
          content_update_time: chapter.content_update_time,
          update_time: chapter.update_time,
          publish_date: chapter.publish_date,
          isFull: 1,
        );
        await HandleDatabase.updateChapterToDB(chapter: updateChapter);
      }
    }
  }

  Future<void> updateChapterContent({required Chapter chapter}) async {
    List<Image> imageChapterContents =
        await _imageRepo.readImageChapterContent(chapterId: chapter.id);
    if (imageChapterContents.isNotEmpty) {
      await _imageRepo.deleteImageChapterContent(chapter: chapter);
    }
    await _imageRepo.createImageChapterContentToDB(chapter: chapter);
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

  // readChapter By Numerical
  Future<List<Image>> readImageFromNextChapter(
      {required String comicId, required int chapterIndex}) async {
    final chapter = await HandleDatabase.readNextChapterByChapterIndex(
        comicId: comicId, chapterIndex: chapterIndex);
    if (chapter != null) {
      return await readChapterContentFromDB(chapterId: chapter.id);
    } else {
      return [];
    }
  }

  Future<Chapter?> readNextChapter(
      {required String comicId, required int chapterIndex}) async {
    Chapter? chapter = await HandleDatabase.readNextChapterByChapterIndex(
        comicId: comicId, chapterIndex: chapterIndex);
    return chapter;
  }

  //
  Future<int> readChapterIndex({required String chapterId}) async {
    Chapter? chapter =
        await HandleDatabase.readChapterByIDFromDB(id: chapterId);
    if (chapter != null) {
      return chapter.chapter_index!;
    }
    return 0;
  }
}
