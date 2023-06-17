// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/get_all_category_bloc/get_all_category_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/get_all_category_bloc/get_all_category_state.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_bloc.dart';
import '../../../../blocs/filter_comic_by_category/filter_comic_event.dart';

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
          return Container(
            padding: EdgeInsets.zero,
            height: SizeConfig.screenHeight / 18.9,
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
                  height: SizeConfig.screenHeight / 25.2,
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
          );
        }
        return const SizedBox.shrink();
      },
      );
  }
}

