import 'package:uuid/uuid.dart';
import '.././models/comic_model.dart';
import '.././providers/database/handle_database.dart';
import '../../config/app_constant.dart';
import '../models/chapter_model.dart';
import '../models/image_model.dart';

class ImageRepo {
  // Create
  Future<void> createImageHomeComicToDB(List<HomeComic> listHomeComic) async {
    final List<Image> listImageObject = [];
    for (var homeComic in listHomeComic) {
      listImageObject.addAll(
        [
          Image(
            id: const Uuid().v4(),
            path: homeComic.image_detail!
                .split("${AppConstant.IMAGEHOMEURL}")
                .removeLast(),
            type: AppConstant.TYPEIMAGEHOMECOMICS[0],
            parent_id: homeComic.id,
          ),
          Image(
            id: const Uuid().v4(),
            path: homeComic.image_detail!
                .split("${AppConstant.IMAGEHOMEURL}")
                .removeLast(),
            type: AppConstant.TYPEIMAGEHOMECOMICS[1],
            parent_id: homeComic.id,
          ),
          Image(
            id: const Uuid().v4(),
            path: homeComic.image_thumnail_square!
                .split("${AppConstant.IMAGEHOMEURL}")
                .removeLast(),
            type: AppConstant.TYPEIMAGEHOMECOMICS[2],
            parent_id: homeComic.id,
          ),
        ],
      );
    }
    await HandleDatabase.createImageToDB(images: listImageObject);
  }

  Future<List<String>> readAllIDImageComicFromDB(
      {required String comicId}) async {
    final List<String> iDImage = [];
    for (String typeHomeComic in AppConstant.TYPEIMAGEHOMECOMICS) {
      Image? image = await HandleDatabase.readImageFromDB(
        type: typeHomeComic,
        parentID: comicId,
      );
      iDImage.add(image!.id);
    }
    return iDImage;
  }

  Future<void> createImageThumnailChapterToDB(
      List<Chapter>? listChapters) async {
    final List<Image> listImageObject = [];
    for (var chapter in listChapters!) {
      listImageObject.addAll(
        [
          Image(
            id: const Uuid().v4(),
            path: chapter.image_thumnail!
                .split("${AppConstant.IMAGETHUMNAILCHAPTERURL}")
                .removeLast(),
            type: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
            parent_id: chapter.id,
          ),
        ],
      );
    }
    await HandleDatabase.createImageToDB(images: listImageObject);
  }

  Future<void> createImageChapterContentToDB(Chapter chapter) async {
    final List<Image> listImageObject = [];
    for (int i = 0; i < chapter.content!.length; i++) {
      listImageObject.addAll(
        [
          Image(
            id: const Uuid().v4(),
            path: chapter.content![i]
                .split("${AppConstant.IMAGECHAPTERCONTENTURL}")
                .removeLast(),
            type: AppConstant.TYPEIMAGECHAPTERCONTENTS,
            parent_id: chapter.id,
            numerical: i + 1,
          ),
        ],
      );
    }
    await HandleDatabase.createImageToDB(images: listImageObject);
  }

  // Read
  Future<String> readIDImageThumnailChapterFromDB(
      {required String chapterId}) async {
    Image? image = await HandleDatabase.readImageFromDB(
      type: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
      parentID: chapterId,
    );
    return image!.id;
  }

  Future<List<Image>?> readImageChapterContent(
      {required String? chapterId}) async {
    return await HandleDatabase.readManyImageFromDB(
        type: AppConstant.TYPEIMAGECHAPTERCONTENTS, parentID: chapterId);
  }

  // Update
  Future<void> updateImageToDB(Image image) async {
    return await HandleDatabase.updateImageToDB(image);
  }

  Future<void> deleteImageChapterContent(Chapter chapter) async {
    await HandleDatabase.deleteImageToDB(
      type: AppConstant.TYPEIMAGECHAPTERCONTENTS,
      parentID: chapter.id,
    );
    await createImageChapterContentToDB(chapter);
  }
}
