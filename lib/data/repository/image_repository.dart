import 'dart:ui';
import '../../config/size_config.dart';
import '../../data/providers/api/api_client.dart';
import '.././models/comic_model.dart';
import '.././providers/database/handle_database.dart';
import '../../config/app_constant.dart';
import '../models/chapter_model.dart';
import '../models/image_model.dart';

class ImageRepo {
  final ApiClient _apiClient;
  // Create

  ImageRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<void> createImageComicToDB({required List<Comic> listComics}) async {
    final List<Image> listImageCreate = [];
    for (var comic in listComics) {
      if (comic.image_detail_id != null && comic.image_detail_path != null) {
        Image imageDetail = Image(
          id: comic.image_detail_id!,
          path: comic.image_detail_path!
              .split("${AppConstant.baseServerUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageComic[0],
          parent_id: comic.id,
        );
        listImageCreate.add(imageDetail);
      }
      if (comic.image_thumnail_square_id != null &&
          comic.image_thumnail_square_path != null) {
        Image imageThumnailSquare = Image(
          id: comic.image_thumnail_square_id!,
          path: comic.image_thumnail_square_path!
              .split("${AppConstant.baseServerUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageComic[1],
          parent_id: comic.id,
        );
        listImageCreate.add(imageThumnailSquare);
      }
      if (comic.image_thumnail_rectangle_id != null &&
          comic.image_thumnail_rectangle_path != null) {
        Image imageThumnailSquare = Image(
          id: comic.image_thumnail_rectangle_id!,
          path: comic.image_thumnail_rectangle_path!
              .split("${AppConstant.baseServerUrl}${AppConstant.imageUrl}")
              .removeLast(),
          type: AppConstant.typeImageComic[2],
          parent_id: comic.id,
        );
        listImageCreate.add(imageThumnailSquare);
      }
    }
    if (listImageCreate.isNotEmpty) {
      await HandleDatabase.createImageToDB(images: listImageCreate);
    } else {
      // print("Home Comic has not image");
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
              .split("${AppConstant.baseServerUrl}${AppConstant.imageUrl}")
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
      // print("Chapter has not image");
    }
  }

  Future<void> createImageChapterContentToDB({required Chapter chapter}) async {
    int height;
    int width;
    final List<Image> listImageObject = [];
    if (chapter.content!.isNotEmpty) {
      for (int i = 0; i < chapter.content!.length; i++) {
        if (chapter.content![i]["id"] != null &&
            chapter.content![i]["path"] != null) {
          if (chapter.content![i]['height'] != null &&
              chapter.content![i]['width'] != null) {
            width = chapter.content![i]['width'];
            height = chapter.content![i]['height'];
          } else {
            width = SizeConfig.screenWidth.round();
            height = (width *
                    await getHeightImage(
                        width: width, path: chapter.content![i]["path"]))
                .round();
          }
          Image imageContent = Image(
            id: chapter.content![i]["id"]!,
            path: chapter.content![i]["path"]!
                .split("${AppConstant.baseServerUrl}${AppConstant.imageUrl}")
                .removeLast(),
            type: AppConstant.typeImageChapterContent,
            height: height,
            width: width,
            parent_id: chapter.id,
            numerical: i + 1,
          );
          listImageObject.add(imageContent);
        }
      }
    }
    if (listImageObject.isNotEmpty) {
      await HandleDatabase.createImageToDB(images: listImageObject);
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
    // print("Delete content");
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
              .split("${AppConstant.baseServerUrl}${AppConstant.imageUrl}")
              .removeLast(),
          parent_id: parentDB.id,
          type: typeImage,
        ),
      );
      return imageID;
    } else if (imageID == null && imagePath != null) {
      await createImageComicToDB(listComics: [parent]);
      return await readIDImageFromDB(
          parentId: parentDB.id, typeImage: typeImage);
    }
    return null;
  }

  Future<double> getHeightImage(
      {required int width, required String path}) async {
    final response = await _apiClient.getData(path);
    final bytes = response.bodyBytes;
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ImageDescriptor.encoded(buffer);
    return width * (descriptor.height / descriptor.width);
  }
}
