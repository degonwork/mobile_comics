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
  final String? image_detail;
  final String? image_detail_id;
  final String? title;
  final String? author;
  final int? year;
  final List<Chapter>? chapters;
  final int? reads;
  final DateTime? chapter_update_time;
  final DateTime? update_time;
  final DateTime? add_chapter_time;
  final String? description;
  final String? image_thumnail_square;
  final String? image_thumnail_square_id;
  final String? image_thumnail_rectangle;
  final String? image_thumnail_rectangle_id;
  final List<String>? categories;

  const Comic({
    required this.id,
    this.image_detail,
    this.image_detail_id,
    this.image_thumnail_rectangle,
    this.image_thumnail_square_id,
    this.image_thumnail_square,
    this.image_thumnail_rectangle_id,
    this.title,
    this.author,
    this.year,
    this.chapters,
    this.reads,
    this.chapter_update_time,
    this.add_chapter_time,
    this.update_time,
    this.description,
    this.categories,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['_id'] ?? json['id'],
      image_detail: json['image_detail'],
      image_thumnail_square: json['image_thumnail_square'],
      image_thumnail_rectangle: json['image_thumnail_rectangle'],
      title: json['title'],
      categories: json['categories'],
      author: json['author'],
      description: json['description'],
      year: json['year'],
      // chapters: json['chapters'].map((json) => Chapter.fromJson(json)),
      chapters: json['chapters'] != null
          ? List.from(json['chapters'].map((json) => Chapter.fromJson(json)))
          : null,
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
      'chapter_update_time': chapter_update_time.toString(),
      'update_time': update_time.toString(),
      'add_chapter_time': add_chapter_time.toString(),
    };
  }
}

class HomeComic {
  final String id;
  final String? title;
  final String image_detail;
  final String image_thumnail_square;
  final String image_thumnail_rectangle;
  final DateTime add_chapter_time;
  final int? reads;

  HomeComic({
    required this.id,
    this.title,
    required this.image_detail,
    required this.image_thumnail_square,
    required this.image_thumnail_rectangle,
    required this.add_chapter_time,
    required this.reads,
  });

  factory HomeComic.fromJson(Map<String, dynamic> json) {
    return HomeComic(
      id: json['id'],
      title: json['title'],
      image_detail: json['image_detail'],
      image_thumnail_square: json['image_thumnail_square'],
      image_thumnail_rectangle: json['image_thumnail_rectangle'],
      add_chapter_time: DateTime.parse(json['add_chapter_time']),
      reads: json['reads'],
    );
  }
}
