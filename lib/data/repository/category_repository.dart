import 'dart:convert';

import '../../config/app_constant.dart';
import '../models/category_model.dart';
import '../providers/api/api_client.dart';
import '../providers/database/handle_database.dart';

class CategoryRepo {
  const CategoryRepo({required this.apiClient});
  final ApiClient apiClient;
  Future<void> getAllCategory() async {
    try {
      final response = await apiClient.getData(AppConstant.categoryAll);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          List<Category> allCategory =
              jsonResponse.map((e) => Category.fromJson(e)).toList();
          await HandleDatabase.createCategoryToDB(listCategories: allCategory);
        }
      }
    } catch (e) {
      print('${e.toString()} ------------------------------------');
    }
  }

  Future<List<Category>> getAllCategoryFromDB() async {
    return await HandleDatabase.readAllCategoryFromDB();
  }

  Future<Category?> readCategoryByIDFromDB({required String id}) async {
    return await HandleDatabase.readCategoryByIDFromDB(id: id);
  }

  Future<Category?> readCategoryByNameFromDB({required String name}) async {
    return await HandleDatabase.readCategoryByNameFromDB(name: name);
  }
}
