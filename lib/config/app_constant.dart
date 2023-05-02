class AppConstant {
  static const BASEURL = "http://10.0.2.2:3000";
  // Comics
  static const COMICURL = "/comics/";
  static const HOTCOMICURL = "home/hot-comic";
  static const NEWCOMICURL = "home/new-comic";
  // Chapter
  static const CHAPTERURL = "/chapters/";
  // Image
  // static const IMAGEURL = "/image/";
  static const IMAGEHOMEURL = "https://i.pinimg.com/564x/47/9a/90/";
  static const IMAGETHUMNAILCHAPTERURL =
      "https://upload.wikimedia.org/wikipedia/vi/b/b7/";
  static const IMAGECHAPTERCONTENTURL = "https://i.ytimg.com/vi/oz_w3RjnTk8/";

  // Type Image Comic
  static const TYPEIMAGEHOMECOMICS = [
    "image_comic_detail",
    "image_thumnail_square_comic",
    "image_thumnail_rectangle_comic",
  ];

  // Type Image chapter
  static const TYPEIMAGETHUMNAILCHAPTER = "image_thumnail_chapter";

  // Type Image chapter content
  static const TYPEIMAGECHAPTERCONTENTS = "image_chapter_content";

// limit
  static const LIMIT = 5;
}
