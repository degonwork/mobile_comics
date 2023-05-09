import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/models/categoriescomics_model.dart';
import 'package:full_comics_frontend/data/models/category_model.dart';
import 'package:full_comics_frontend/data/providers/database/handle_database.dart';
import '.././models/chapter_model.dart';

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
  ];

  static final String id = 'id';
  static final String image_detail_id = 'image_detail_id';
  static final String image_thumnail_square_id = 'image_thumnail_square_id';
  static final String image_thumnail_rectangle_id =
      'image_thumnail_rectangle_id';
  static final String title = 'title';
  static final String author = 'author';
  static final String year = 'year';
  static final String reads = 'reads';
  static final String chapter_update_time = 'chapter_update_time';
  static final String update_time = 'update_time';
  static final String add_chapter_time = 'add_chapter_time';
  static final String description = 'description';
}

class Comic {
  final String id;
  final String? image_detail_path;
  final String? image_detail_id;
  final String? title;
  final String? author;
  final int? year;
  final List<Chapter> chapters;
  final int? reads;
  final DateTime? chapter_update_time;
  final DateTime? update_time;
  final DateTime? add_chapter_time;
  final String? description;
  final String? image_thumnail_square_path;
  final String? image_thumnail_square_id;
  final String? image_thumnail_rectangle_path;
  final String? image_thumnail_rectangle_id;
  final List<dynamic> categories;

  const Comic({
    required this.id,
    this.image_detail_path,
    this.image_detail_id,
    this.image_thumnail_rectangle_path,
    this.image_thumnail_square_id,
    this.image_thumnail_square_path,
    this.image_thumnail_rectangle_id,
    this.title,
    this.author,
    this.year,
    required this.chapters,
    this.reads,
    this.chapter_update_time,
    this.add_chapter_time,
    this.update_time,
    this.description,
    required this.categories,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['_id'] ?? json['id'],
      image_detail_path: json['image_detail_path'],
      image_thumnail_square_path: json['image_thumnail_square_path'],
      image_thumnail_rectangle_path: json['image_thumnail_rectangle_path'],
      title: json['title'],
      categories:
          json['categories'] != null ? List.from(json['categories']) : [],
      author: json['author'],
      description: json['description'],
      year: json['year'],
      chapters: json['chapters'] != null
          ? List.from(json['chapters']).isNotEmpty
              ? List.from(
                  json['chapters'].map((json) => Chapter.fromJson(json)))
              : []
          : [],
      reads: json['reads'],
      chapter_update_time: json['chapter_update_time'] != null
          ? json['chapter_update_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['chapter_update_time'])
              : DateTime.parse(json['chapter_update_time'])
          : null,
      update_time: json['update_time'] != null
          ? json['update_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['update_time'])
              : DateTime.parse(json['update_time'])
          : null,
      add_chapter_time: json['add_chapter_time'] != null
          ? json['add_chapter_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['add_chapter_time'])
              : DateTime.parse(json['add_chapter_time'])
          : null,
      image_detail_id: json["image_detail_id"],
      image_thumnail_rectangle_id: json["image_thumnail_rectangle_id"],
      image_thumnail_square_id: json["image_thumnail_square_id"],
    );
  }

  static Future<Comic> copyWith(Comic comic) async {
    final listCategories = [];
    List<CategoriesComics>? categoriesComic =
        await HandleDatabase.readAllCategoriesComicsFromDB(comicID: comic.id);
    if (categoriesComic != null) {
      for (var i = 0; i < categoriesComic.length; i++) {
        Category? category = await HandleDatabase.readCategoryByIDFromDB(
          id: categoriesComic[i].category_id,
        );
        listCategories.add(category!.name);
      }
    }
    String? imageDetailUrl = (await HandleDatabase.readImageFromDB(
            type: AppConstant.TYPEIMAGECOMICS[0], parentID: comic.id))!
        .path;
    String? imageThumnailSquareUrl = (await HandleDatabase.readImageFromDB(
            type: AppConstant.TYPEIMAGECOMICS[1], parentID: comic.id))!
        .path;
    String? imageThumnailRectangleUrl = (await HandleDatabase.readImageFromDB(
            type: AppConstant.TYPEIMAGECOMICS[2], parentID: comic.id))!
        .path;
    return Comic(
      id: comic.id,
      image_detail_path:
          "${AppConstant.baseServerUrl}${AppConstant.IMAGEURL}$imageDetailUrl",
      image_thumnail_square_path:
          "${AppConstant.baseServerUrl}${AppConstant.IMAGEURL}$imageThumnailSquareUrl",
      image_thumnail_rectangle_path:
          "${AppConstant.baseServerUrl}${AppConstant.IMAGEURL}$imageThumnailRectangleUrl",
      title: comic.title,
      author: comic.author,
      description: comic.description,
      categories: listCategories,
      chapters: [],
      year: comic.year,
      reads: comic.reads,
      chapter_update_time: comic.chapter_update_time,
      update_time: comic.update_time,
      add_chapter_time: comic.add_chapter_time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_detail_id': image_detail_id,
      'image_thumnail_rectangle_id': image_thumnail_rectangle_id,
      'image_thumnail_square_id': image_thumnail_square_id,
      'title': title,
      'author': author,
      'description': description,
      'year': year,
      'reads': reads,
      'chapter_update_time': chapter_update_time?.toString(),
      'update_time': update_time?.toString(),
      'add_chapter_time': add_chapter_time?.toString(),
    };
  }
}
