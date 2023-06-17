import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/comic_detail/comic_detail_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';
import 'package:full_comics_frontend/config/ui_constant.dart';
import '../../../../config/size_config.dart';
import '../../detail/comic_detail_screen.dart';

class ComicByCategory extends StatelessWidget {
  const ComicByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterComicBloc, FilterComicState>(
        builder: (context, state) {
      if (state is LoadedComicByCategoryID) {
        final listComicsFilter = state.listComics;
        if (listComicsFilter.isNotEmpty) {
          return GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listComicsFilter.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return SizedBox(
                height: SizeConfig.screenHeight / 3.78,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listComicsFilter[index].image_thumnail_square_path != null
                        ? Expanded(
                            child: CachedNetworkImage(
                            imageUrl: listComicsFilter[index]
                                .image_thumnail_square_path!,
                            imageBuilder: (context, imageProvider) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<ComicDetailBloc>().add(
                                      LoadDetailComic(
                                          listComicsFilter[index].id));
                                  Navigator.pushNamed(
                                      context, ComicDetailScreen.routeName);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: SizeConfig.screenHeight / 37.8),
                                  // height: SizeConfig.screenHeight,
                                  height: SizeConfig.screenHeight / 4.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/banner_splash.png"),
                            )
                          )
                        : Expanded(child: Image.asset("assets/images/banner_splash.png")),
                        SizedBox(height: SizeConfig.screenHeight / 75.6,),
                        Text(
                          listComicsFilter[index].title != null ? '${listComicsFilter[index].title}' : '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleComic,
                        ),
                        SizedBox(height: SizeConfig.screenHeight / 75.6,),
                        
                      ],
                ),
              );
            },
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.amber));
        }
      }
      return const Center(
          child: CircularProgressIndicator(color: Colors.amber));
    });
  }
}
