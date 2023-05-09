import '../../config/app_constant.dart';
import '.././repository/image_repository.dart';
import '../models/chapter_model.dart';
import '../models/image_model.dart';
import '../providers/database/handle_database.dart';

class ChapterRepo {
  final ImageRepo _imageRepo;
  final String _chapterUrl;

  ChapterRepo({required ImageRepo imageRepo, required String chapterUrl})
      : _chapterUrl = chapterUrl,
        _imageRepo = imageRepo;
  //  Fetch Api
  Future fetchDetailChapters({required String id}) async {
    // final response =
    // await _apiClient.getData('$_chapterUrl/$id');
    // if (response.statusCode == 200) {
    // dynamic jsonResponse = jsonDecode(response.body);
    try {
      // final chapter = Chapter.fromJson(jsonResponse);
      // await updateChapterToDB(chapter);
      // await updateChapterContent(chapter);
      // Chapter? chapterRe = await readChapterByIdFromDB(id: "chapter5");
      // print(chapterRe!.update_time);
      // List<Image>? imageChapterContents =
      //     await _imageRepo.readImageChapterContent(
      //   chapterId: "chapter1",
      // );
      // print(imageChapterContents);
    } catch (e) {
      // print(e.toString());
    }

    // return chapter;
    // }
    // else {
    // throw Exception('Load failed');
    // }
  }

  // process database
  Future<void> createChapterToDB(
      {required List<Chapter> listHomeComicChapter}) async {
    await _imageRepo.createImageThumnailChapterToDB(
        listChapters: listHomeComicChapter);
    List<Chapter> listChapters = [];
    for (int i = 0; i < listHomeComicChapter.length; i++) {
      String? imageThumnailID =
          await _imageRepo.readIDImageThumnailChapterFromDB(
              chapterId: listHomeComicChapter[i].id);
      if (imageThumnailID != null) {
        listChapters.addAll([
          Chapter(
            id: listHomeComicChapter[i].id,
            image_thumnail_id: imageThumnailID,
            chapter_des: listHomeComicChapter[i].chapter_des,
            numerical: i + 1,
            content: listHomeComicChapter[i].content,
          )
        ]);
      }
    }
    if (listChapters.isNotEmpty) {
      await HandleDatabase.createChapterToDB(chapters: listChapters);
    } else {
      print("Chapter is not available");
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
      await _imageRepo.updateImageToDB(
          image: Image(
        id: chapterDB.image_thumnail_id!,
        path: chapter.image_thumnail_path!
            .split("${AppConstant.baseLocalUrl}${AppConstant.IMAGEURL}")
            .removeLast(),
        parent_id: chapterDB.id,
        type: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
      ));
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
