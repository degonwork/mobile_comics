
import 'package:full_comics_frontend/data/models/comic_model.dart';

class AppConstant {
  static const baseServerUrl = "http://117.4.194.207:3000";
  // static const baseLocalUrl = "http://localhost:3000";
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

  // Type Image chapter thumnail
  static const typeImageThumnailChapter = "image_thumnail_chapter";

  // Type Image chapter content
  static const typeImageChapterContent = "image_chapter_content";

// limit
  static const limitHomeComic = 6;
  static const limitSeeMoreComic = 20;
// category
// static const category = "/category/";
static const categoryAll = "/category/all";
// Error
  static const comicNotExist = Comic(id: "Not-exist");
}
