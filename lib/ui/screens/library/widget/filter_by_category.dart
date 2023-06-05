// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';

class FilterComicByCategory extends StatelessWidget {
  const FilterComicByCategory({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocBuilder(
      builder: (context,state){
        if (state is LoadedComicByCategoryID) {
          final listComicsByCategoryID = state.listComics;
          print(listComicsByCategoryID);
          return ListView(
           scrollDirection: Axis.vertical,
           children: List.generate(listComicsByCategoryID.length, (index) => Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
           )),
          );
        }
        return const  CircularProgressIndicator();
      }
      
      );
    
  }
}