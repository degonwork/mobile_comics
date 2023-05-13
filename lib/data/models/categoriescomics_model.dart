const String tableCategoriesComics = 'CategoriesComics';

class CategoriesComicsField {
  static final List<String> values = [
    id,
    comic_id,
    category_id,
  ];

  static String id = 'id';
  static String comic_id = 'comic_id';
  static String category_id = 'category_id';
}

class CategoriesComics {
  final String id;
  final String comic_id;
  final String category_id;

  CategoriesComics({
    required this.id,
    required this.comic_id,
    required this.category_id,
  });

  factory CategoriesComics.fromJson(Map<String, dynamic> json) {
    return CategoriesComics(
      id: json['_id'] ?? json['id'],
      comic_id: json['comic_id'],
      category_id: json['category_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comic_id': comic_id,
      'category_id': category_id,
    };
  }
}
