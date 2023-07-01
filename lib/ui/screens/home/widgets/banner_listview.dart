import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/home/home_bloc.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../config/size_config.dart';
import '../../detail/comic_detail_screen.dart';

class BannerListview extends StatelessWidget {
  const BannerListview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final listHotComics = state.lisHotComics;
          if (listHotComics.isNotEmpty) {
            return CarouselSlider.builder(
              itemCount: listHotComics.length,
              itemBuilder: (context, index, index1) {
                return listHotComics[index].image_thumnail_rectangle_path !=
                        null
                    ? CachedNetworkImage(
                        imageUrl:
                            listHotComics[index].image_thumnail_rectangle_path!,
                        imageBuilder: (context, imageProvider) {
                          return GestureDetector(
                            onTap: () {
                              context.read<ComicDetailBloc>().add(
                                  LoadDetailComic(listHotComics[index].id));
                              Navigator.pushNamed(
                                  context, ComicDetailScreen.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.radius10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/banner_splash.png"),
                      )
                    : Image.asset("assets/images/banner_splash.png");
              },
              options: CarouselOptions(
                height: SizeConfig.height180,
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
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: AppColor.circular));
          }
        }
        return const Center(
            child: CircularProgressIndicator(color: AppColor.circular));
      },
    );
  }
}
