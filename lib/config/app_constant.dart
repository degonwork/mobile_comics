import 'package:full_comics_frontend/data/models/case_comic_model.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';

class AppConstant {
  static const baseServerUrl = "http://117.4.194.207:3000";
  // Comics
  static const comicUrl = "/comics/";
  static const hotComicUrl = "home/hot-comics";
  static const newComicUrl = "home/new-comics";
  // Chapter
  static const chapterUrl = "/chapters/";
  // Image
  static const imageUrl = "/image/";

  // Type Image Comic
  static const typeImageComic = [
    "image_comic_detail",
    "image_thumnail_square_comic",
    "image_thumnail_rectangle_comic",
  ];
  // Device
  static const deviceUrl = "/device/";
  static const registerDeviceUrl = "create";

  // Type Image Comic

  // SharePrefrence
  static const String firebaseToken = "Firebase-token";
  static const String uuidDevice = "Uuid-device";
  static const String timeAdsLocal = "Times-ads";
  static const String listCaseComics = "List-case-comics";

  // Type Image chapter thumnail
  static const typeImageThumnailChapter = "image_thumnail_chapter";

  // Type Image chapter content
  static const typeImageChapterContent = "image_chapter_content";

// limit
  static const limitHomeComic = 6;
  static const limitSeeMoreComic = 20;
// category

  static const categoryAll = "/category/all";
// Error
  static const comicNotExist = Comic(id: "Not-exist");

// Error

  static const caseComicNotExist = CaseComic(
      comicId: "Not-exist", chapterId: "Not-exist", numericChapter: 0);
}
