
import 'package:full_comics_frontend/data/providers/api/api_client.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../providers/database/handle_database.dart';

class CategoryRepo {
  const CategoryRepo({required this.apiClient});
  final ApiClient? apiClient;
  Future<int?> createCategoryToDB(String category) async {
    Category createCategory = Category(
      id: const Uuid().v4(),
      name: category,
    );
    return await HandleDatabase.createCategoryToDB(category: createCategory);
  }

  Future<Category?> readCategoryByIDFromDB({required String id}) async {
    return await HandleDatabase.readCategoryByIDFromDB(id: id);
  }

  Future<Category?> readCategoryByNameFromDB({required String name}) async {
    return await HandleDatabase.readCategoryByNameFromDB(name: name);
  }
  
}
