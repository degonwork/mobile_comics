import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/home/home_bloc.dart';
import '../../../../config/size_config.dart';
import '../../detail/comic_detail_screen.dart';

class BannerListview extends StatelessWidget {
  const BannerListview({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final listHotComics = state.listHotComics;
          if (listHotComics.isNotEmpty) {
            return SizedBox(
              height: SizeConfig.screenHeight * 0.266,
              child: CarouselSlider.builder(
                itemCount: listHotComics.length,
                itemBuilder: (context, index, index1) {
                  return CachedNetworkImage(
                    imageUrl:
                        listHotComics[index].image_thumnail_rectangle_path!,
                    imageBuilder: (context, imageProvider) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ComicDetailScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                options: CarouselOptions(
                  height: SizeConfig.screenHeight * 0.265,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            );
          }
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
