const String tableImages = 'Images';

class ImageField {
  static List<String> values = [
    id,
    path,
    type,
    height,
    width,
    parent_id,
    numerical
  ];
  static String id = 'id';
  static String path = 'path';
  static String type = 'type';
  static String height = 'height';
  static String width = 'width';
  static String parent_id = 'parent_id';
  static String numerical = 'numerical';
}

class Image {
  final String id;
  final String path;
  final String type;
  final String parent_id;
  final int? height;
  final int? width;
  final int? numerical;

  Image({
    required this.id,
    required this.path,
    required this.type,
    this.height,
    this.width,
    required this.parent_id,
    this.numerical,
    
  });
  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      path: json["path"],
      type: json['type'],
      height: json['height'],
      width: json['width'],
      parent_id: json['parent_id'],
      numerical: json['numerical'],
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'type': type,
      'height': height,
      'width': width,
      'parent_id': parent_id,
      'numerical': numerical,
    };
  }
}
