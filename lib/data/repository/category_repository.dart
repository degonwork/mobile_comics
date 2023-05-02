import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../providers/database/handle_database.dart';

class CategoryRepo {
  Future<int?> createCategoryToDB(String category) async {
    Category createCategory = Category(
      id: const Uuid().v4(),
      name: category,
    );
    return await HandleDatabase.createCategoryToDB(category: createCategory);
  }

  Future<Category?> readCategoryByNameFromDB({required String name}) async {
    return HandleDatabase.readCategoryByNameFromDB(name: name);
  }
}
