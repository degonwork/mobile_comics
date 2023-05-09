import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../blocs/home/home_bloc.dart';
import '../../../../config/size_config.dart';
import '../../detail/comic_detail_screen.dart';

class NewComic extends StatelessWidget {
  const NewComic({super.key});

  @override
  Widget build(BuildContext context) {
    // final ComicDetailBloc comicDetailBloc;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final listNewComics = state.listNewComics;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth * 0.041,
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listNewComics.length,
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
                      CachedNetworkImage(
                        imageUrl:
                            listNewComics[index].image_thumnail_square_path!,
                        imageBuilder: (context, imageProvider) {
                          return GestureDetector(
                            onTap: () {
                              context.read<ComicDetailBloc>().add(LoadDetailComic(listNewComics[index].id));
                              Navigator.pushNamed(
                                context, ComicDetailScreen.routeName);
                            },
                            child: Container(
                              margin: EdgeInsets.zero,
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
                      ),
                      Text(
                        ' ${listNewComics[index].title} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return Center(
          child: Image.asset(
            "assets/images/banner_splash.png",
            height: SizeConfig.screenHeight * 0.2,
          ),
        );
      },
    );
  }
}
