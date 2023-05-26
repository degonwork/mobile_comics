import 'package:full_comics_frontend/data/models/comic_model.dart';

class AppConstant {
  static const baseServerUrl = "http://10.0.2.2:3000";
  static const baseLocalUrl = "http://localhost:3000";
  // Comics
  static const COMICURL = "/comics/";
  static const HOTCOMICURL = "home/hot-comics";
  static const NEWCOMICURL = "home/new-comics";
  // Chapter
  static const CHAPTERURL = "/chapters/";
  // Image
  static const IMAGEURL = "/image/";
  // Device
  static const DEVICEURL = "/device/";
  static const REGISTERDEVICEURL = "create";

  // Type Image Comic
  static const TYPEIMAGECOMICS = [
    "image_detail_comic",
    "image_thumnail_square_comic",
    "image_thumnail_rectangle_comic",
  ];

  // SharePrefrence
  static const String FIREBASETOKEN = "Firebase-token";
  static const String UUIDDEVICE = "Uuid-device";

  // Type Image chapter thumnail
  static const TYPEIMAGETHUMNAILCHAPTER = "image_thumnail_chapter";

  // Type Image chapter content
  static const TYPEIMAGECHAPTERCONTENTS = "image_chapter_content";

// limit
  static const LIMITHOMECOMIC = 6;
  static const LIMITVIEWMORECOMIC = 20;

// Error
  static const COMICNOTEXIST = Comic(id: "Not-exist");
}
