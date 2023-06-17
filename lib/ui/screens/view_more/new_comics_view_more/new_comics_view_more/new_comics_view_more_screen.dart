import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/ui_constant.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';
import '../../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../../blocs/view_more/view_more_bloc.dart';
import '../../../../widgets/back_ground_app.dart';
import '../../../../../config/size_config.dart';
import '../../../detail/comic_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewComicViewMoreScreen extends StatelessWidget {
  const NewComicViewMoreScreen({super.key});
  static const String routeName = '/new-comics-view-more';

  @override
  Widget build(BuildContext context) {
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
                      TextUi(
                        text: AppLocalizations.of(context)!.newComics,
                        fontSize: SizeConfig.font20,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
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
                                              ? Expanded(
                                                  child: CachedNetworkImage(
                                                    imageUrl: listNewComicsViewMore[
                                                            index]
                                                        .image_thumnail_square_path!,
                                                    imageBuilder: (context,
                                                        imageProvider) {
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
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
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
                                                  ),
                                                )
                                              : Image.asset(
                                                  "assets/images/banner_splash.png"),
                                          SizedBox(
                                            height:
                                                SizeConfig.screenHeight / 75.6,
                                          ),
                                          Text(
                                            listNewComicsViewMore[index]
                                                        .title !=
                                                    null
                                                ? listNewComicsViewMore[index]
                                                    .title!
                                                : "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: titleComic,
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.amber));
                      }
                    }
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.amber));
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
