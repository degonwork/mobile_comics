import 'package:uuid/uuid.dart';
import '.././models/comic_model.dart';
import '.././providers/database/handle_database.dart';
import '../../config/app_constant.dart';
import '../models/chapter_model.dart';
import '../models/image_model.dart';

class ImageRepo {
  // Create
  Future<void> createImageComicToDB(
      {required List<Comic> listHomeComic}) async {
    final List<Image> listImageObject = [];
    for (var homeComic in listHomeComic) {
      if (homeComic.image_detail_path != null) {
        Image? imageDetail = Image(
          id: const Uuid().v4(),
          path: homeComic.image_detail_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.IMAGEURL}")
              .removeLast(),
          type: AppConstant.TYPEIMAGECOMICS[0],
          parent_id: homeComic.id,
        );
        listImageObject.add(imageDetail);
      }
      if (homeComic.image_thumnail_square_path != null) {
        Image? imageThumnailSquare = Image(
          id: const Uuid().v4(),
          path: homeComic.image_thumnail_square_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.IMAGEURL}")
              .removeLast(),
          type: AppConstant.TYPEIMAGECOMICS[1],
          parent_id: homeComic.id,
        );
        listImageObject.add(imageThumnailSquare);
      }
      if (homeComic.image_thumnail_rectangle_path != null) {
        Image? imageThumnailSquare = Image(
          id: const Uuid().v4(),
          path: homeComic.image_thumnail_rectangle_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.IMAGEURL}")
              .removeLast(),
          type: AppConstant.TYPEIMAGECOMICS[2],
          parent_id: homeComic.id,
        );
        listImageObject.add(imageThumnailSquare);
      }
    }
    if (listImageObject.isNotEmpty) {
      await HandleDatabase.createImageToDB(images: listImageObject);
    } else {
      print("Home Comic has not image");
    }
  }

  Future<List<String>> readAllIDImageComicFromDB(
      {required String comicId}) async {
    final List<String> iDImage = [];
    for (int i = 0; i < AppConstant.TYPEIMAGECOMICS.length; i++) {
      Image? image = await HandleDatabase.readImageFromDB(
        type: AppConstant.TYPEIMAGECOMICS[i],
        parentID: comicId,
      );
      if (image != null) {
        iDImage.add(image.id);
      }
    }
    return iDImage;
  }

  Future<void> createImageThumnailChapterToDB(
      {required List<Chapter> listChapters}) async {
    final List<Image> listImageObject = [];
    for (var chapter in listChapters) {
      if (chapter.image_thumnail_path != null) {
        Image imageThumnail = Image(
          id: const Uuid().v4(),
          path: chapter.image_thumnail_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.IMAGEURL}")
              .removeLast(),
          type: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
          parent_id: chapter.id,
        );
        listImageObject.add(imageThumnail);
      }
    }
    if (listImageObject.isNotEmpty) {
      await HandleDatabase.createImageToDB(images: listImageObject);
    } else {
      print("Chapter has not image");
    }
  }

  Future<void> createImageChapterContentToDB({required Chapter chapter}) async {
    final List<Image> listImageObject = [];
    if (chapter.content.isNotEmpty) {
      for (int i = 0; i < chapter.content.length; i++) {
        Image imageContent = Image(
          id: const Uuid().v4(),
          path: chapter.content[i]
              .split("${AppConstant.baseLocalUrl}${AppConstant.IMAGEURL}")
              .removeLast(),
          type: AppConstant.TYPEIMAGECHAPTERCONTENTS,
          parent_id: chapter.id,
          numerical: i + 1,
        );
        listImageObject.add(imageContent);
      }
    }
    if (listImageObject.isNotEmpty) {
      await HandleDatabase.createImageToDB(images: listImageObject);
    } else {
      print("Chapter has not content");
    }
  }

  // Read
  Future<String?> readIDImageThumnailChapterFromDB(
      {required String chapterId}) async {
    Image? image = await HandleDatabase.readImageFromDB(
      type: AppConstant.TYPEIMAGETHUMNAILCHAPTER,
      parentID: chapterId,
    );
    if (image != null) {
      return image.id;
    }
    return null;
  }

  Future<List<Image>> readImageChapterContent(
      {required String chapterId}) async {
    return await HandleDatabase.readManyImageFromDB(
        type: AppConstant.TYPEIMAGECHAPTERCONTENTS, parentID: chapterId);
  }

  // Update
  Future<void> updateImageToDB({required Image image}) async {
    return await HandleDatabase.updateImageToDB(image: image);
  }

  Future<void> deleteImageChapterContent({required Chapter chapter}) async {
    await HandleDatabase.deleteImageToDB(
      type: AppConstant.TYPEIMAGECHAPTERCONTENTS,
      parentID: chapter.id,
    );
    print("Delete content");
    await createImageChapterContentToDB(chapter: chapter);
  }
}
