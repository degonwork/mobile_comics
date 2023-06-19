import 'dart:convert';
import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/providers/api/api_client.dart';
import '../models/category_model.dart';
import '../providers/database/handle_database.dart';

class CategoryRepo {
  const CategoryRepo({required this.apiClient});
  final ApiClient apiClient;
  Future<List<Category>> getAllCategory() async {
    try {
      final response = await apiClient.getData(AppConstant.categoryAll);
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          final allCategory =
              jsonResponse.map((e) => Category.fromJson(e)).toList();
          await HandleDatabase.createCategoryToDBByID(categories: allCategory);
        }
      }
    } catch (e) {
      print(
          '${e.toString()} fgajiogsgsjglsgjkls------------------------------------');
    }
    return await HandleDatabase.readAllCategoryFromDB();
    
  }
Future<List<Category>> getAllCategoryFromDB()async{
  return await HandleDatabase.readAllCategoryFromDB();
}
  Future<int?> createCategoryToDB(Category category) async {
    Category createCategory = Category(
      id: category.id,
      name: category.name,
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
