const String tableCategories = 'Categories';

class CategoryField {
  static final List<String> values = [
    id,
    name,
  ];

  static String id = 'id';
  static String name = 'name';
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"] ?? json["id"],
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
