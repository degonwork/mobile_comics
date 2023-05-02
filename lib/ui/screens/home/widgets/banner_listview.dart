import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../.././detail/comic_detail_screen.dart';
import '../../../../config/size_config.dart';

class BannerListview extends StatelessWidget {
  const BannerListview({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.screenHeight * 0.266,
      child: CarouselSlider.builder(
        itemCount: 2,
        itemBuilder: (context, index, index1) {
          return CachedNetworkImage(
            imageUrl: "",
            imageBuilder: (context, imageProvider) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ComicDetailScreen.routeName);
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
