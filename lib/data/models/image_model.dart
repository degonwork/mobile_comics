import '../../config/app_constant.dart';

const String tableImages = 'Images';

class ImageField {
  static List<String> values = [id, path, type, parent_id, numerical];
  static String id = 'id';
  static String path = 'path';
  static String type = 'type';
  static String parent_id = 'parent_id';
  static String numerical = 'numerical';
}

class Image {
  final String id;
  final String path;
  final String type;
  final String parent_id;
  final int? numerical;

  Image({
    required this.id,
    required this.path,
    required this.type,
    required this.parent_id,
    this.numerical,
  });
 static Future<Image> copyWith(Image image) async {
  return Image(id: image.id, path: '${AppConstant.baseServerUrl}${AppConstant.IMAGEURL}${image.path}', type: image.type, parent_id: image.parent_id);
 }
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
