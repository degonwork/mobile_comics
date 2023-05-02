import '../../config/app_constant.dart';
import '.././repository/image_repository.dart';
import '../dummy/dummy_data.dart';
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
      dynamic jsonResponse = detailChapterJson;
      final chapter = Chapter.fromJson(jsonResponse);
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
      print(e.toString());
    }

    // return chapter;
    // }
    // else {
    // throw Exception('Load failed');
    // }
  }

  // process database
  Future<void> createChapterToDB(List<Chapter> listHomeComicChapter) async {
    await _imageRepo.createImageThumnailChapterToDB(listHomeComicChapter);
    await _imageRepo.createImageThumnailChapterToDB(listHomeComicChapter);
    List<Chapter>? listChapters = [];
    for (int i = 0; i < listHomeComicChapter.length; i++) {
      String iDImage = await _imageRepo.readIDImageThumnailChapterFromDB(
          chapterId: listHomeComicChapter[i].id);
      listChapters.addAll([
        Chapter(
          id: listHomeComicChapter[i].id,
          image_thumnail_id: iDImage,
          chapter_des: listHomeComicChapter[i].chapter_des,
          numerical: i + 1,
        )
      ]);
    }
    await HandleDatabase.createChapterToDB(chapters: listChapters);
  }

  Future<Chapter?> readChapterByIdFromDB({required String id}) async {
    return HandleDatabase.readChapterByIDFromDB(id: id);
  }

  Future<void> updateChapterToDB(Chapter chapter) async {
    await _imageRepo.createImageChapterContentToDB(chapter);
    Chapter? chapterDB =
        await HandleDatabase.readChapterByIDFromDB(id: chapter.id);
    await _imageRepo.updateImageToDB(Image(
      id: chapterDB!.image_thumnail_id!,
      path: chapter.image_thumnail!
          .split("${AppConstant.IMAGETHUMNAILCHAPTERURL}")
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
    );
    await HandleDatabase.updateChapterToDB(updateChapter);
  }

  Future<void> updateChapterContent(Chapter chapter) async {
    List<Image>? imageChapterContents =
        await _imageRepo.readImageChapterContent(chapterId: chapter.id);
    if (imageChapterContents != null) {
      await _imageRepo.deleteImageChapterContent(chapter);
      print("deleted");
    }
    _imageRepo.createImageChapterContentToDB(chapter);
  }
}
