const String tableImages = 'Images';

class ImageField {
  static final List<String> values = [id, path, type, parent_id, numerical];
  static final String id = 'id';
  static final String path = 'path';
  static final String type = 'type';
  static final String parent_id = 'parent_id';
  static final String numerical = 'numerical';
}

class Image {
  final String id;
  final String? path;
  final String? type;
  final String? parent_id;
  final int? numerical;

  Image({
    required this.id,
    required this.path,
    this.type,
    this.parent_id,
    this.numerical,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      path: json["path"],
      type: json['type'],
      parent_id: json['parent_id'],
      numerical: json['numerical'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'type': type,
      'parent_id': parent_id,
      'numerical': numerical,
    };
  }
}
