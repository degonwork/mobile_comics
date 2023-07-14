import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/ads/ads_bloc.dart';
import '../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_event.dart';
import '../../../config/app_color.dart';
import '../../../ui/widgets/build_ads_banner.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_state.dart';
import '../../../config/size_config.dart';
import '../../../data/models/comic_model.dart';
import '../../widgets/back_button_screen.dart';
import '../../widgets/text_ui.dart';
import '../detail/comic_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({
    super.key,
    required this.comic,
  });

  final Comic comic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width20),
              child: const BannerAD()),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.height20),
                  child: BlocBuilder<ReadChapterBloc, ReadChapterState>(
                    builder: (context, state) {
                      if (state is LoadingChapter) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: AppColor.circular),
                        );
                      } else if (state is LoadedChapter) {
                        final listImage = state.listImageContent;
                        if (listImage.isNotEmpty) {
                          return GestureDetector(
                            onTap: () => context.read<ReadChapterBloc>().add(
                                  SetStateButtonBackIndex(state.visialbe),
                                ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: listImage.length,
                                      itemBuilder: (context, index) {
                                        final imageUrl = listImage[index].path;
                                        return listImage[index].height !=
                                                    null &&
                                                listImage[index].width != null
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      SizeConfig.width10,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrl,
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return SizedBox(
                                                      width: SizeConfig
                                                          .screenWidth,
                                                      height: SizeConfig
                                                              .screenWidth *
                                                          (listImage[index]
                                                                  .width! /
                                                              listImage[index]
                                                                  .height!),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          "assets/images/anh splash.jpg"),
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/images/anh splash.jpg");
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                ),
                BlocBuilder<ReadChapterBloc, ReadChapterState>(
                  builder: (context, state) {
                    if (state is LoadedChapter) {
                      return Container(
                        margin: EdgeInsets.only(top: SizeConfig.height5),
                        child: AnimatedOpacity(
                          opacity: state.visialbe ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 400),
                          child: NavigatorButtonScreen(
                            icon: Icons.arrow_back_ios_outlined,
                            onTap: () {
                              context.read<CaseBloc>().add(
                                    AddCaseComic(
                                      chapterId: state.chapterId,
                                      comicId: comic.id,
                                      imageThumnailSquareComicPath:
                                          comic.image_thumnail_square_path!,
                                      numericChapter: state.currentNumeric,
                                      titleComic: comic.title,
                                      reads: comic.reads,
                                    ),
                                  );
                              context
                                  .read<ComicDetailBloc>()
                                  .add(LoadDetailComic(comic.id, true));
                              Navigator.pushNamed(
                                  context, ComicDetailScreen.routeName);
                            },
                          ),
                        ),
                      );
                    }
                    return NavigatorButtonScreen(
                      icon: Icons.arrow_back_ios_outlined,
                      onTap: () => Navigator.pushNamed(
                          context, ComicDetailScreen.routeName),
                    );
                  },
                ),
                BlocBuilder<ReadChapterBloc, ReadChapterState>(
                  builder: (context, state) {
                    if (state is LoadedChapter) {
                      final listPath = state.listImageContent;
                      if (state.currentNumeric < comic.chapters!.length) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.screenHeight * 0.8,
                              left: SizeConfig.screenWidth * 0.8),
                          child: AnimatedOpacity(
                            opacity: state.visialbe ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            child: NavigatorButtonScreen(
                              icon: Icons.arrow_right_alt_outlined,
                              onTap: () async {
                                context.read<AdsBloc>().add(Increment());
                                context.read<ReadChapterBloc>().add(
                                      LoadNextChapter(
                                        comic.id,
                                        state.currentNumeric,
                                      ),
                                    );
                                for (var i = 0; i < listPath.length; i++) {
                                  await CachedNetworkImage.evictFromCache(
                                    listPath[i].path,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                    return NavigatorButtonScreen(
                      icon: Icons.arrow_right_alt_outlined,
                      onTap: () => Navigator.pushNamed(
                          context, ComicDetailScreen.routeName),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
