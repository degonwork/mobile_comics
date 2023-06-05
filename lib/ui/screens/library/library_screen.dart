import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import 'package:full_comics_frontend/data/models/category_model.dart';
import 'package:full_comics_frontend/data/providers/api/api_client.dart';
// import 'package:full_comics_frontend/ui/screens/library/widget/filter_by_category.dart';
// import 'package:full_comics_frontend/ui/screens/library/widget/filter_by_category.dart';

import '../../../config/app_constant.dart';

// import '../../../config/app_constant.dart';

// import '../../../config/app_constant.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Category>> getAllCategory;
    final apiClient = const ApiClient(baseServerUrl: AppConstant.baseServerUrl);
  @override
  void initState(){
    super.initState();
    getAllCategory = fetchAllCategory();
  }
  Future<List<Category>> fetchAllCategory()async{
   
      try {
      final response = await apiClient.getData(AppConstant.categoryAll);
     
     
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
     
         if (jsonResponse.isNotEmpty) {
           final allCategory = jsonResponse.map((e) => Category.fromJson(e)).toList();
           
           return allCategory;
         }
    }
    } catch (e) {
      print(e.toString());
    }
  return [];
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SizedBox(
          
          child: Column(
            children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight / 90),
              height: SizeConfig.screenHeight / 15,
              decoration: const BoxDecoration(
                
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const TextField(
                keyboardType: TextInputType.text,
                
                decoration: InputDecoration(
                  hintText: "Tim kiem truyen,the loai",
                  hintTextDirection: TextDirection.ltr,
                  border: InputBorder.none,
                  
                ),
              ),
            ),
            FutureBuilder(
              future: getAllCategory,
              builder: (context,snapshot){
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                  return SizedBox(
                    height: 50,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(snapshot.data!.length, (index) => InkWell(
                        onTap: () {
                          context.read<FilterComicBloc>().add(FilterByIDCategory(snapshot.data![index].id));
                          // Navigator.push(
                            
                          //   , MaterialPageRoute(builder: (_) => const FilterComicByCategory()));
                        },
                        child: Container(
                          height: 50,
                          width: SizeConfig.screenWidth / 5,
                          margin:  EdgeInsets.only(left: SizeConfig.screenWidth / 36 ,right: SizeConfig.screenWidth / 72),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.4),
                            border: Border.all(width: 1,color: Colors.grey),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Container(
                          margin:const  EdgeInsets.all(5),
                          child: Center(child: Text(snapshot.data![index].name,style: const TextStyle(fontSize: 12),)),
                        ),
                      )),
                    )),
                  );
                }
                }
                return const CircularProgressIndicator();
              },
            
            ),
            ],
          ),
        ),
      ),
    );
  }
}
