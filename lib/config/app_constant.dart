class AppConstant {
  static const BASESERVERURL = "http://10.0.2.2:3000";
  static const BASELOCALURL = "http://localhost:3000";
  // Comics
  static const COMICURL = "/comics/";
  static const HOTCOMICURL = "home/hot-comics";
  static const NEWCOMICURL = "home/new-comics";
  // Chapter
  static const CHAPTERURL = "/chapters/";
  // Image
  static const IMAGEURL = "/image/";

  // Type Image Comic
  static const TYPEIMAGECOMICS = [
    "image_comic_detail",
    "image_thumnail_square_comic",
    "image_thumnail_rectangle_comic",
  ];

  // Type Image chapter thumnail
  static const TYPEIMAGETHUMNAILCHAPTER = "image_thumnail_chapter";

  // Type Image chapter content
  static const TYPEIMAGECHAPTERCONTENTS = "image_chapter_content";

// limit
  static const LIMITHOMECOMIC = 6;
  static const LIMITSEEMORECOMIC = 20;
}
