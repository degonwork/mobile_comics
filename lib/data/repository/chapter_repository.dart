import 'dart:convert';
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
  ChapterRepo(
      {required ImageRepo imageRepo,
      required String chapterUrl,
      required ApiClient apiClient})
      : _chapterUrl = chapterUrl,
        _apiClient = apiClient,
        _imageRepo = imageRepo;
  //  Fetch Api
  Future<List<Image>> fetchDetailChapters({required String id}) async {
    List<Image> images = [];
    try {
      final response = await _apiClient.getData('$_chapterUrl$id');
      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          final chapter = Chapter.fromJson(jsonResponse);
          await updateChapterToDB(chapter: chapter);
          List<Image> imageChapterContent =
              await _imageRepo.readImageChapterContent(chapterId: id);
          if (imageChapterContent.isNotEmpty) {
            imageChapterContent.sort((imageChapterContent1,
                    imageChapterContent2) =>
                imageChapterContent1.numerical! -
                imageChapterContent2.numerical!);
            for (var i = 0; i < imageChapterContent.length; i++) {
              Image image = Image(
                  id: imageChapterContent[i].id,
                  path:
                      '${AppConstant.baseServerUrl}${AppConstant.imageUrl}${imageChapterContent[i].path}',
                  type: imageChapterContent[i].type,
                  parent_id: imageChapterContent[i].parent_id);
              images.add(image);
            }
          }
        } else {
          print("chapter is not available");
          throw Exception("Not Found Data");
        }
      } else {
        throw Exception('Load failed chapter');
      }
    } catch (e) {
      print(e.toString());
    }

    return images;
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
          ),
        );
      }
      await HandleDatabase.createChapterToDB(chapters: listChapters);
    } else {
      print("Comic has not Chapters");
    }
  }

  Future<void> updateChapterToDB({required Chapter chapter}) async {
    Chapter? chapterDB =
        await HandleDatabase.readChapterByIDFromDB(id: chapter.id);
    if (chapterDB != null) {
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
        numerical: chapterDB.numerical,
        content_update_time: chapter.content_update_time,
        update_time: chapter.update_time,
        content: chapter.content,
      );
      await HandleDatabase.updateChapterToDB(chapter: updateChapter);
    } else {
      print("Chapter is not updated");
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
}
