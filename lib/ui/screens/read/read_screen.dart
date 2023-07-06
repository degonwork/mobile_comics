import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_event.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import 'package:full_comics_frontend/ui/widgets/build_ads_banner.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_state.dart';
import '../../../config/size_config.dart';
import '../../../data/models/comic_model.dart';
import '../../widgets/back_button_screen.dart';
import '../detail/comic_detail_screen.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({
    super.key,
    this.chapterId,
    this.comic,
   
  });
  final String? chapterId;
  final Comic? comic;
 

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width20),
              child: const BannerAD()),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height50),
            child: BlocBuilder<ReadChapterBloc, ReadChapterState>(
              builder: (context, state) {
                if (state is LoadingChapter) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.disable),
                  );
                } else if (state is LoadedChapter) {
                  final listImage = state.listImageContent;
                  // print(
                  // '${state.currentNumeric} -----------------------------+++++++++++++++++++++++++++++++++++++++++++++');
                  if (listImage.isNotEmpty) {
                    return GestureDetector(
                      onTap: () => context.read<ReadChapterBloc>().add(
                            SetStateButtonBackIndex(state.visialbe),
                          ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listImage.length,
                              itemBuilder: (context, index) {
                                return listImage[index].height != null &&
                                        listImage[index].width != null
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.width10,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: listImage[index].path,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return SizedBox(
                                              width: SizeConfig.screenWidth,
                                              height: SizeConfig.screenWidth *
                                                  (listImage[index].width! /
                                                      listImage[index].height!),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/images/banner_splash.png"),
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/images/banner_splash.png");
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.disable),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.disable),
                );
              },
            ),
          ),
          BlocBuilder<ReadChapterBloc, ReadChapterState>(
            builder: (context, state) {
              if (state is LoadedChapter) {
                return Container(
                  margin: EdgeInsets.only(top: SizeConfig.height50),
                  child: AnimatedOpacity(
                    opacity: state.visialbe ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: NavigatorButtonScreen(
                      icon: Icons.arrow_back_ios_outlined,
                      onTap: () {
                        if (comic != null &&
                            chapterId != null
                            ) {
                          context.read<CaseBloc>().add(
                                AddCaseComic(
                                  chapterId: chapterId!,
                                  comicId: comic!.id,
                                  imageThumnailSquareComicPath:
                                      comic!.image_thumnail_square_path!,
                                  numericChapter: state.currentNumeric,
                                  titleComic: comic!.title!,
                                  reads: comic!.reads!,
                                ),
                              );
                        }
                        Navigator.pushNamed(
                            context, ComicDetailScreen.routeName);
                      },
                    ),
                  ),
                );
              }
              return NavigatorButtonScreen(
                icon: Icons.arrow_back_ios_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, ComicDetailScreen.routeName),
              );
            },
          ),
          BlocBuilder<ReadChapterBloc, ReadChapterState>(
            builder: (context, state) {
              if (state is LoadedChapter) {
                print(state.currentNumeric.toString() + 'currenttttttttttttttttttttttttttttttttttttttttttttt');
                return Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.85,left: SizeConfig.screenWidth * 0.8),
                  child: AnimatedOpacity(
                    opacity: state.visialbe ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: NavigatorButtonScreen(
                      icon: Icons.arrow_right_alt_outlined,
                      onTap: () {
                        context.read<ReadChapterBloc>().add(LoadNextChapter(comic!.id, state.currentNumeric));
                        
                      },
                    ),
                  ),
                );
              }
              return NavigatorButtonScreen(
                icon: Icons.arrow_right_alt_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, ComicDetailScreen.routeName),
              );
            },
          ),
        ],
      ),
    );
  }
}
