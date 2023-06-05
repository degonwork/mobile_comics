import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../../blocs/view_more/view_more_bloc.dart';
import '../../../../widgets/back_ground_app.dart';
import '../../../../../config/size_config.dart';
import '../../../detail/comic_detail_screen.dart';

class NewComicViewMoreScreen extends StatelessWidget {
  const NewComicViewMoreScreen({super.key});
  static const String routeName = '/new-comics-view-more';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.screenHeight * 0.04,
            ),
            child: Column(
              children: [
                MediaQuery.removePadding(
                  context: context,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                      const Text(
                        "More New Comics",
                        style: TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                BlocBuilder<ViewMoreBloc, ViewMoreState>(
                  builder: (context, state) {
                    if (state is ViewMoreLoaded) {
                      final listNewComicsViewMore = state.listNewComicsViewMore;
                      if (listNewComicsViewMore.isNotEmpty) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: listNewComicsViewMore.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: SizeConfig.screenHeight / 3.78,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          listNewComicsViewMore[index]
                                                      .image_thumnail_square_path !=
                                                  null
                                              ? CachedNetworkImage(
                                                  imageUrl: listNewComicsViewMore[
                                                          index]
                                                      .image_thumnail_square_path!,
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                ComicDetailBloc>()
                                                            .add(
                                                              LoadDetailComic(
                                                                  listNewComicsViewMore[
                                                                          index]
                                                                      .id),
                                                            );
                                                        Navigator.pushNamed(
                                                            context,
                                                            ComicDetailScreen
                                                                .routeName);
                                                      },
                                                      child: Container(
                                                        height: SizeConfig
                                                                .screenHeight /
                                                            4.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          "assets/images/banner_splash.png"),
                                                )
                                              : Image.asset(
                                                  "assets/images/banner_splash.png"),
                                          Text(
                                            listNewComicsViewMore[index]
                                                        .title !=
                                                    null
                                                ? listNewComicsViewMore[index]
                                                    .title!
                                                : "",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        );
                      }
                    }
                    return const Text(
                      "Comics not found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
