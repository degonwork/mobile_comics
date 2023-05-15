import 'dart:convert';

import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/providers/api/api_client.dart';

import '../../config/app_constant.dart';
import '.././repository/image_repository.dart';
import '../models/chapter_model.dart';
import '../models/image_model.dart';
import '../providers/database/handle_database.dart';

class ChapterRepo {
  final ImageRepo _imageRepo;
  final String _chapterUrl;
  final ApiClient _apiClient;
  ChapterRepo({required ImageRepo imageRepo, required String chapterUrl,required ApiClient apiClient})
      : _chapterUrl = chapterUrl,
        _apiClient = apiClient,
        _imageRepo = imageRepo;
  //  Fetch Api
  Future<List<Image>> fetchDetailChapters({required String id}) async {
    try {
      final response = await _apiClient.getData('$_chapterUrl$id');
      if (response.statusCode == 200) {
        dynamic jsonResponse =jsonDecode(response.body);
        final chapter = Chapter.fromJson(jsonResponse);
        await updateChapterToDB(chapter: chapter);
        List<Image> imageChapterContent = await _imageRepo.readImageChapterContent(chapterId: id);
       List<Image> images = [];
       for (var i = 0; i < imageChapterContent.length; i++) {
        Image image = Image(id: imageChapterContent[i].id, path: '${AppConstant.baseServerUrl}${AppConstant.IMAGEURL}${imageChapterContent[i].path}', type: imageChapterContent[i].type, parent_id: imageChapterContent[i].parent_id);
        images.add(image);
       }
        return images;
      }else{
        throw Exception('Load failed chapter');
      }
     
      
    } catch (e) {
      print(e.toString());
    }
    return [];
   
  }

  // process database
  Future<void> createChapterToDB(
      {required Comic comic}) async {
        if (comic.chapters!.isNotEmpty) {
    await _imageRepo.createImageThumnailChapterToDB(
        listChapters: comic.chapters!);
    List<Chapter> listChapters = [];
    for (int i = 0; i < comic.chapters!.length; i++) {
      String? imageThumnailID = await _imageRepo.readIDImageFromDB(
        parentId: comic.chapters![i].id,
        typeImage: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
      );
      listChapters.addAll([
        Chapter(
          comic_id: comic.id,
          id: comic.chapters![i].id,
          image_thumnail_id: imageThumnailID,
          chapter_des: comic.chapters![i].chapter_des,
          numerical: i + 1,
          content: comic.chapters![i].content,
        )
      ]);
    }
    await HandleDatabase.createChapterToDB(chapters: listChapters);
  }
      }
  Future<Chapter?> readChapterByIdFromDB({required String id}) async {
    return HandleDatabase.readChapterByIDFromDB(id: id);
  }

  Future<void> updateChapterToDB({required Chapter chapter}) async {
   
    await _imageRepo.createImageChapterContentToDB(chapter: chapter);
    Chapter? chapterDB =
        await HandleDatabase.readChapterByIDFromDB(id: chapter.id);
    if (chapterDB != null) {
      await _imageRepo.createOrUpdateImage(
        imageID: chapterDB.image_thumnail_id,
        imagePath: chapter.image_thumnail_path,
        parentDB: chapterDB,
        typeImage: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
        parent: chapter,
      );
      Chapter updateChapter = Chapter(
        id: chapter.id,
        comic_id: chapter.comic_id,
        image_thumnail_id: chapterDB.image_thumnail_id,
        chapter_des: chapter.chapter_des,
        numerical: chapterDB.numerical,
        content_update_time: chapter.content_update_time,
        update_time: chapter.update_time,
        content: chapter.content,
      );
      await HandleDatabase.updateChapterToDB(chapter: updateChapter);
    }
  }

  Future<void> updateChapterContent({required Chapter chapter}) async {
    List<Image> imageChapterContents =
        await _imageRepo.readImageChapterContent(chapterId: chapter.id);
    if (imageChapterContents.isNotEmpty) {
      await _imageRepo.deleteImageChapterContent(chapter: chapter);
      print("deleted content");
    }
    _imageRepo.createImageChapterContentToDB(chapter: chapter);
  }
}
