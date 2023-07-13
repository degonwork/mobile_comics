import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/ads/ads_bloc.dart';
import '../../../config/app_color.dart';
import '../../../ui/widgets/build_ads_banner.dart';
import '../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../config/app_constant.dart';
import '../../widgets/back_button_screen.dart';
import '../../widgets/back_ground_app.dart';
import '../../../config/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/text_ui.dart';
import '../router/router_screen.dart';
import 'screens/chapter.dart';
import 'screens/infor.dart';

class ComicDetailScreen extends StatelessWidget {
  const ComicDetailScreen({super.key});

  static const String routeName = '/comic-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height70),
            child: BlocBuilder<ComicDetailBloc, ComicDetailState>(
              builder: (context, state) {
                if (state is ComicDetailLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppColor.circular));
                }
                if (state is ComicDetailLoaded) {
                  final comic = state.comic;
                  final caseComic = state.caseComic;
                  if (comic != AppConstant.comicNotExist) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          bottom: PreferredSize(
                            preferredSize:
                                const Size.fromHeight(double.minPositive),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: SizeConfig.height17),
                              child: TextUi(
                                text: comic.title,
                                fontSize: SizeConfig.font30,
                                color: AppColor.titleComicColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          pinned: true,
                          expandedHeight: SizeConfig.height160,
                          flexibleSpace: FlexibleSpaceBar(
                            background: comic.image_detail_path != null
                                ? CachedNetworkImage(
                                    imageUrl: comic.image_detail_path!,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/anh splash.jpg"),
                                  )
                                : Image.asset("assets/images/anh splash.jpg"),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context.read<ComicDetailBloc>().add(
                                          const SetStateComicDetailIndex(0));
                                    },
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth / 2,
                                      height: SizeConfig.height55,
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.height10),
                                          TextUi(
                                            text: AppLocalizations.of(context)!
                                                .inforComics,
                                            fontSize: SizeConfig.font16,
                                            color: state.index == 0
                                                ? AppColor.buttonTextSelectColor
                                                : AppColor.unSelectTitleColor,
                                          ),
                                          SizedBox(height: SizeConfig.height5),
                                          Divider(
                                            color: state.index == 0
                                                ? AppColor.brownColor
                                                    .withOpacity(0.5)
                                                : Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.read<ComicDetailBloc>().add(
                                          const SetStateComicDetailIndex(1));
                                    },
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth / 2,
                                      height: SizeConfig.height55,
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.height10),
                                          TextUi(
                                            text: AppLocalizations.of(context)!
                                                .chapters,
                                            fontSize: SizeConfig.font16,
                                            color: state.index == 1
                                                ? AppColor.buttonTextSelectColor
                                                : AppColor.unSelectTitleColor,
                                          ),
                                          SizedBox(height: SizeConfig.height5),
                                          Divider(
                                            color: state.index == 1
                                                ? AppColor.brownColor
                                                    .withOpacity(0.5)
                                                : Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.height420,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.width15,
                                  ),
                                  child: state.index == 0
                                      ? Infor(
                                          comic: comic,
                                          caseComic: caseComic,
                                        )
                                      : ListChapter(
                                          comic: comic,
                                          caseComic: caseComic,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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
          Container(
            padding: EdgeInsets.only(
                top: SizeConfig.height10, left: SizeConfig.width20),
            child: BlocBuilder<AdsBloc, AdsState>(
              builder: (context, state) {
                if (state is AdsShow) {
                  if (state.hasError != true) {
                    return const BannerAD();
                  }
                }
                return Container();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height35),
            child: NavigatorButtonScreen(
                icon: Icons.arrow_back_ios_outlined,
                onTap: () {
                  Navigator.pushNamed(context, RouterScreen.routeName);
                }),
          ),
        ],
      ),
    );
  }
}
