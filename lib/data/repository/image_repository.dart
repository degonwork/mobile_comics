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
      if (homeComic.image_detail_id != null &&
          homeComic.image_detail_path != null) {
        Image imageDetail = Image(
          id: homeComic.image_detail_id!,
          path: homeComic.image_detail_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageComic[0],
          parent_id: homeComic.id,
        );
        listImageObject.add(imageDetail);
      }
      if (homeComic.image_thumnail_square_id != null &&
          homeComic.image_thumnail_square_path != null) {
        Image imageThumnailSquare = Image(
          id: homeComic.image_thumnail_square_id!,
          path: homeComic.image_thumnail_square_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageComic[1],
          parent_id: homeComic.id,
        );
        listImageObject.add(imageThumnailSquare);
      }
      if (homeComic.image_thumnail_rectangle_id != null &&
          homeComic.image_thumnail_rectangle_path != null) {
        Image imageThumnailSquare = Image(
          id: homeComic.image_thumnail_rectangle_id!,
          path: homeComic.image_thumnail_rectangle_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageComic[2],
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

  Future<void> createImageThumnailChapterToDB(
      {required List<Chapter> listChapters}) async {
    final List<Image> listImageObject = [];
    for (var chapter in listChapters) {
      if (chapter.image_thumnail_id != null &&
          chapter.image_thumnail_path != null) {
        Image imageThumnail = Image(
          id: chapter.image_thumnail_id!,
          path: chapter.image_thumnail_path!
              .split("${AppConstant.baseLocalUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageThumnailChapter,
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
    if (chapter.content!.isNotEmpty) {
      for (int i = 0; i < chapter.content!.length; i++) {
        if (chapter.content![i]["id"] != null &&
            chapter.content![i]["path"] != null &&
            chapter.content![i]["height"] != null &&
            chapter.content![i]["width"] != null) {
          Image imageContent = Image(
            id: chapter.content![i]["id"]!,
            path: chapter.content![i]["path"]!
                .split("${AppConstant.baseLocalUrl}${AppConstant.imageUrl}")
                .removeLast(),
            type: AppConstant.typeImageChapterContent,
            height: chapter.content![i]['height'],
            width: chapter.content![i]['width'],
            parent_id: chapter.id,
            numerical: i + 1,
          );
          listImageObject.add(imageContent);
        }
      }
    }
    if (listImageObject.isNotEmpty) {
      await HandleDatabase.createImageToDB(images: listImageObject);
    } else {
      print("Chapter has not content");
    }
  }

// Read
  Future<String?> readIDImageFromDB({
    required String parentId,
    required String typeImage,
  }) async {
    Image? image = await HandleDatabase.readImageFromDB(
      type: typeImage,
      parentID: parentId,
    );
    if (image != null) {
      return image.id;
    }
    return null;
  }

  Future<List<Image>> readImageChapterContent(
      {required String chapterId}) async {
    return await HandleDatabase.readManyImageFromDB(
      type: AppConstant.typeImageChapterContent,
      parentID: chapterId,
    );
  }

// delete
  Future<void> deleteImageChapterContent({required Chapter chapter}) async {
    await HandleDatabase.deleteImageToDB(
      type: AppConstant.typeImageChapterContent,
      parentID: chapter.id,
    );
    print("Delete content");
  }

  // More
  Future<String?> createOrUpdateImage({
    required String? imageID,
    required String? imagePath,
    required dynamic parentDB,
    required String typeImage,
    required dynamic parent,
  }) async {
    if (imageID != null && imagePath != null) {
      await HandleDatabase.updateImageToDB(
        image: Image(
          id: imageID,
          path: imagePath
              .split("${AppConstant.baseLocalUrl}${AppConstant.imageUrl}")
              .removeLast(),
          parent_id: parentDB.id,
          type: typeImage,
        ),
      );
      print("${typeImage} is updated");
      return imageID;
    } else if (imageID == null && imagePath != null) {
      await createImageComicToDB(listHomeComic: [parent]);
      print("${typeImage} is created");
      return await readIDImageFromDB(
          parentId: parentDB.id, typeImage: typeImage);
    }
    return null;
  }
}
