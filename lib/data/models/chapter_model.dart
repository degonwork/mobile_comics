const String tableChapters = 'Chapters';

class ChapterField {
  static final List<String> values = [
    id,
    image_thumnail_id,
    comic_id,
    chapter_des,
    chapter_index,
    content_update_time,
    update_time,
    isFull,
    
  ];

  static String id = 'id';
  static String image_thumnail_id = 'image_thumnail_id';
  static String comic_id = 'comic_id';
  static String chapter_des = 'chapter_des';
  static String chapter_index = 'chapter_index';
  static String content_update_time = 'content_update_time';
  static String update_time = 'update_time';
  static String isFull = 'isFull';
}

class Chapter {
  final String id;
  final String? comic_id;
  final String? image_thumnail_path;
  final String? image_thumnail_id;
  final String? chapter_des;
  final int? chapter_index;
  final DateTime? publish_date;
  final List<Map<String, dynamic>>? content;
  final DateTime? content_update_time;
  final DateTime? update_time;
  final int isFull;

  const Chapter({
    required this.id,
    this.comic_id,
    this.image_thumnail_path,
    this.image_thumnail_id,
    this.chapter_des,
    this.chapter_index,
    this.publish_date,
    this.content,
    this.content_update_time,
    this.update_time,
    required this.isFull,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['_id'] ?? json['id'] ?? json['chapter_id'],
      comic_id: json['comic_id'],
      image_thumnail_id: json['image_thumnail'] != null
          ? json["image_thumnail"]["id"]
          : json['image_thumnail_id'],
      image_thumnail_path: json['image_thumnail'] != null
          ? json["image_thumnail"]["path"]
          : null,
      chapter_des: json['chapter_des'],
      publish_date: json['publish_date'] != null
          ? json['publish_date'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['publish_date'])
              : DateTime.parse(json['publish_date'])
          : null,
      content: json['content'] != null
          ? List<dynamic>.from(json['content'])
              .map((json) => Map<String, dynamic>.from(json))
              .toList()
          : [],
      chapter_index: json['chapter_index'],
      content_update_time: json['content_update_time'] != null
          ? json['content_update_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['content_update_time'])
              : DateTime.parse(json['content_update_time'])
          : null,
      update_time: json['update_time'] != null
          ? json['update_time'] is int
              ? DateTime.fromMillisecondsSinceEpoch(json['update_time'])
              : DateTime.parse(json['update_time'])
          : null,
      isFull: json["isFull"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comic_id': comic_id,
      'image_thumnail_id': image_thumnail_id,
      'chapter_des': chapter_des,
      'chapter_index': chapter_index,
      'content_update_time': content_update_time?.toString(),
      'update_time': update_time?.toString(),
      'isFull': isFull
    };
  }
}
