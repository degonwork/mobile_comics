import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/router/router_bloc.dart';
import '../../../../ui/widgets/text_ui.dart';
import '../../../../blocs/home/home_bloc.dart';
import '../../../../config/app_color.dart';
import '../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../config/size_config.dart';
import '../../detail/comic_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../router/router_screen.dart';

class BannerListview extends StatelessWidget {
  const BannerListview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColor.circular));
        }
        if (state is HomeLoaded) {
          final listHotComics = state.lisHotComics;
          if (listHotComics.isNotEmpty) {
            return CarouselSlider.builder(
              itemCount: listHotComics.length,
              itemBuilder: (context, index, index1) {
                return listHotComics[index].image_thumnail_rectangle_path !=
                        null
                    ? InkWell(
                        onTap: () {
                          context.read<ComicDetailBloc>().add(
                              LoadDetailComic(listHotComics[index].id, false));
                          Navigator.pushNamed(
                              context, ComicDetailScreen.routeName);
                          context.read<RouterBloc>().add(
                                const SetRouterScreen(
                                  RouterScreen.routeName,
                                ),
                              );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.radius10),
                            image: DecorationImage(
                              image: NetworkImage(listHotComics[index]
                                  .image_thumnail_rectangle_path!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Image.asset("assets/images/anh splash.jpg");
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
          }
        }
        return Center(
          child: TextUi(
            text: AppLocalizations.of(context)!.notFoundComics,
            color: Colors.white,
            fontSize: SizeConfig.font16,
          ),
        );
      },
    );
  }
}
