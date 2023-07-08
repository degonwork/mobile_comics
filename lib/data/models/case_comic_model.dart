class CaseComic {
  final String comicId;
  final String chapterId;
  final String? imageThumnailSquareComicPath;
  final String titleComic;
  final int reads;
  final int numericChapter;

  const CaseComic({
    required this.comicId,
    required this.chapterId,
    this.imageThumnailSquareComicPath,
    required this.titleComic,
    required this.reads,
    required this.numericChapter,
  });

  factory CaseComic.fromJson(Map<String, dynamic> json) {
    return CaseComic(
      comicId: json["comic_id"],
      chapterId: json["chapter_id"],
      imageThumnailSquareComicPath: json["image_thumnail_squareComic_path"],
      titleComic: json["title_comic"] ?? "",
      reads: json["reads"] ?? 1000,
      numericChapter: json["numeric_chapter"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "comic_id": comicId,
      "chapter_id": chapterId,
      "image_thumnail_squareComic_path": imageThumnailSquareComicPath,
      "title_comic": titleComic,
      "numeric_chapter": numericChapter,
      "reads": reads,
    };
  }
}
