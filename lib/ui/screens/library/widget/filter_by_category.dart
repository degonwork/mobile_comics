// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
// import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';

import 'package:full_comics_frontend/blocs/filter_comic_by_category/get_all_category_bloc/get_all_category_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/get_all_category_bloc/get_all_category_state.dart';
import 'package:full_comics_frontend/config/size_config.dart';

import '../../../../blocs/filter_comic_by_category/filter_comic_bloc.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_event.dart';
import 'comic_filter_by_category.dart';

class FilterComicByCategory extends StatefulWidget {
  const FilterComicByCategory({super.key});

  @override
  State<FilterComicByCategory> createState() => _FilterComicByCategoryState();
}

class _FilterComicByCategoryState extends State<FilterComicByCategory> {
 int? selected;
  @override
  Widget build(BuildContext context) {
     return BlocBuilder<GetAllCategoryBloc,GetAllCategoryState>(
      builder: (context,state){
        if (state is GetLoading) {
          return const CircularProgressIndicator();
        }else if(state is GetLoadded){
          final listCategories = state.listCategories;
          
          return SizedBox(
            height: SizeConfig.screenHeight,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(listCategories.length, (index) => InkWell(
                      onTap: (){
                        context.read<FilterComicBloc>().add(FilterByIDCategory(listCategories[index].id));
                        setState(() {
                          selected= index;

                        });
                      },
                      child: Container(
                        // height: SizeConfig.screenHeight / 25.2,
                        width: SizeConfig.screenWidth / 3.6,
                        margin: EdgeInsets.only(right: SizeConfig.screenWidth / 36),
                        decoration: BoxDecoration(
                          color: selected == index ? Colors.orange.withOpacity(0.8) : Colors.blue.withOpacity(0.4) ,
                          border: Border.all(width: 1,color: Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Container(
                          margin:const  EdgeInsets.all(5),
                          child: Center(child: Center(child: Text(listCategories[index].name,style: const TextStyle(fontSize: 12),)),),
                        ),
                      ),
                    )),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight / 50.4,),
                const Expanded(
                  flex: 18,
                  child: SizedBox(
                  height: double.maxFinite,
                  child: ComicByCategory())),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },

      );

  }
}


// v2
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
// import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';

// import 'package:full_comics_frontend/config/size_config.dart';
// import 'package:full_comics_frontend/data/models/category_model.dart';
// import 'package:full_comics_frontend/data/providers/api/api_client.dart';
// import 'package:full_comics_frontend/ui/screens/library/widget/comic_filter_by_category.dart';


// import '../../../../config/app_constant.dart';

// class FilterScreen extends StatefulWidget {
//   const FilterScreen({super.key});

//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends State<FilterScreen> {
//   late Future<List<Category>> getAllCategory;
//   final apiClient = const ApiClient(baseServerUrl: AppConstant.baseServerUrl);
//   @override
//   void initState() {
//     super.initState();
//     getAllCategory = fetchAllCategory();
//   }

//   Future<List<Category>> fetchAllCategory() async {
//     try {
//       final response = await apiClient.getData(AppConstant.categoryAll);

//       if (response.statusCode == 200) {
//         List jsonResponse = jsonDecode(response.body);

//         if (jsonResponse.isNotEmpty) {
//           final allCategory =
//               jsonResponse.map((e) => Category.fromJson(e)).toList();

//           return allCategory;
//         }
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getAllCategory,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data!.isNotEmpty) {
//             return SizedBox(
//               height: 50,
//               child: ListView(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: false,
//                   scrollDirection: Axis.horizontal,
//                   children: List.generate(
//                     snapshot.data!.length,
//                     (index) => InkWell(
//                         onTap: () {
//                           context.read<FilterComicBloc>().add(
//                             FilterByIDCategory(snapshot.data![index].id));
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const ComicByCategory()));
//                         },
//                         child: Container(
//                           height: 50,
//                           width: SizeConfig.screenWidth / 5,
//                           margin: EdgeInsets.only(
//                               // left: SizeConfig.screenWidth / 36,
//                               right: SizeConfig.screenWidth / 36),
//                           decoration: BoxDecoration(
//                               color: Colors.brown.withOpacity(0.4),
//                               border: Border.all(width: 1, color: Colors.grey),
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(10))),
//                           child: Container(
//                             margin: const EdgeInsets.all(5),
//                             child: Center(
//                                 child: Text(
//                               snapshot.data![index].name,
//                               style: const TextStyle(fontSize: 12),
//                             )),
//                           ),
//                         )),
//                   )),
//             );
//           }
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }
