import '../../config/app_constant.dart';
import '.././models/chapter_model.dart';
import 'image_model.dart';

const String tableComics = 'Comics';

class ComicField {
  static final List<String> values = [
    id,
    image_detail_id,
    image_thumnail_square_id,
    image_thumnail_rectangle_id,
    title,
    author,
    year,
    description,
    reads,
    chapter_update_time,
    update_time,
    add_chapter_time,
    isFull
  ];

  static String id = 'id';
  static String image_detail_id = 'image_detail_id';
  static String image_thumnail_square_id = 'image_thumnail_square_id';
  static String image_thumnail_rectangle_id = 'image_thumnail_rectangle_id';
  static String title = 'title';
  static String author = 'author';
  static String year = 'year';
  static String reads = 'reads';
  static String chapter_update_time = 'chapter_update_time';
  static String update_time = 'update_time';
  static String add_chapter_time = 'add_chapter_time';
  static String description = 'description';
  static String isFull = 'isFull';
}

class Comic {
  final String id;
  final String? image_detail_path;
  final String? image_detail_id;
  final String? image_thumnail_square_path;
  final String? image_thumnail_square_id;
  final String? image_thumnail_rectangle_path;
  final String? image_thumnail_rectangle_id;
  final String title;
  final String author;
  final int year;
  final List<Chapter>? chapters;
  final int reads;
  final DateTime chapter_update_time;
  final DateTime update_time;
  final DateTime add_chapter_time;
  final String description;
  final List<String>? categories;
  final int? times_ads;
  final int isFull;

  const Comic({
    required this.id,
    this.image_detail_path,
    this.image_detail_id,
    this.image_thumnail_rectangle_path,
    this.image_thumnail_square_id,
    this.image_thumnail_square_path,
    this.image_thumnail_rectangle_id,
    required this.title,
    required this.author,
    required this.year,
    this.chapters,
    required this.reads,
    required this.chapter_update_time,
    required this.add_chapter_time,
    required this.update_time,
    required this.description,
    this.categories,
    this.times_ads,
    required this.isFull,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['_id'] ?? json['id'],
      image_detail_id: json['image_detail'] != null
          ? json["image_detail"]["id"]
          : json['image_detail_id'],
      image_detail_path:
          json['image_detail'] != null ? json["image_detail"]["path"] : null,
      image_thumnail_square_id: json['image_thumnail_square'] != null
          ? json["image_thumnail_square"]["id"]
          : json['image_thumnail_square_id'],
      image_thumnail_square_path: json['image_thumnail_square'] != null
          ? json["image_thumnail_square"]["path"]
          : null,
      image_thumnail_rectangle_id: json['image_thumnail_rectangle'] != null
          ? json["image_thumnail_rectangle"]["id"]
          : json['image_thumnail_rectangle_id'],
      image_thumnail_rectangle_path: json['image_thumnail_rectangle'] != null
          ? json["image_thumnail_rectangle"]["path"]
          : null,
      title: json['title'] ?? "",
      categories:
          json['categories'] != null ? List.from(json['categories']) : [],
      author: json['author'] ?? "",
      description: json['description'] ?? "",
      year: json['year'] ?? 2000,
      chapters: json['chapters'] != null
          ? List.from(json['chapters']).isNotEmpty
              ? List.from(json['chapters'].map((jsonChapter) {
                  jsonChapter['comic_id'] = json['_id'] ?? json['id'];
                  return Chapter.fromJson(jsonChapter);
                }))
              : []
          : [],
      reads: json['reads'] ?? 1000,
      chapter_update_time: json['chapter_update_time'] != null
          ? json['chapter_update_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['chapter_update_time'])
              : DateTime.parse(json['chapter_update_time'])
          : AppConstant.jsonTimeNull,
      update_time: json['update_time'] != null
          ? json['update_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['update_time'])
              : DateTime.parse(json['update_time'])
          : AppConstant.jsonTimeNull,
      add_chapter_time: json['add_chapter_time'] != null
          ? json['add_chapter_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['add_chapter_time'])
              : DateTime.parse(json['add_chapter_time'])
          : AppConstant.jsonTimeNull,
      times_ads: json["times_ads"] ?? 5,
      isFull: json["isFull"] ?? 0,
    );
  }
  static Comic copyWith(
    Comic comic, {
    List<String>? listCategories,
    List<Chapter>? listChapters,
    Image? imageDetail,
    Image? imageThumnailSquare,
    Image? imageThumnailRectangle,
    required String id,
    required int isFull,
  }) {
    return Comic(
      id: comic.id,
      image_detail_path: imageDetail != null
          ? "${AppConstant.baseServerUrl}${AppConstant.imageUrl}${imageDetail.path}"
          : null,
      image_thumnail_square_path: imageThumnailSquare != null
          ? "${AppConstant.baseServerUrl}${AppConstant.imageUrl}${imageThumnailSquare.path}"
          : null,
      image_thumnail_rectangle_path: imageThumnailRectangle != null
          ? "${AppConstant.baseServerUrl}${AppConstant.imageUrl}${imageThumnailRectangle.path}"
          : null,
      title: comic.title,
      author: comic.author,
      description: comic.description,
      categories: listCategories ?? [],
      chapters: listChapters ?? [],
      year: comic.year,
      reads: comic.reads,
      chapter_update_time: comic.chapter_update_time,
      update_time: comic.update_time,
      add_chapter_time: comic.add_chapter_time,
      isFull: comic.isFull,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_detail_id': image_detail_id,
      'image_thumnail_square_id': image_thumnail_square_id,
      'image_thumnail_rectangle_id': image_thumnail_rectangle_id,
      'title': title,
      'author': author,
      'description': description,
      'year': year,
      'reads': reads,
      'chapter_update_time': chapter_update_time.toString(),
      'update_time': update_time.toString(),
      'add_chapter_time': add_chapter_time.toString(),
      'isFull': isFull
    };
  }
}
