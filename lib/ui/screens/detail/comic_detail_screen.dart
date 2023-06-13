import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/ui/screens/detail/screens/chapter.dart';
import 'package:full_comics_frontend/ui/screens/detail/screens/infor.dart';
import '../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../config/app_constant.dart';
import '../../widgets/back_ground_app.dart';

import '../../../config/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComicDetailScreen extends StatefulWidget {
  const ComicDetailScreen({super.key});
  static const String routeName = '/comic-detail';

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen>
    with TickerProviderStateMixin {
  late List<Tab> tabs = [];
  late TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Tab> tabs = <Tab>[
      Tab(text: AppLocalizations.of(context)!.inforComics),
      Tab(text: AppLocalizations.of(context)!.chapters),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          BlocBuilder<ComicDetailBloc, ComicDetailState>(
            builder: (context, state) {
              if (state is ComicDetailLoaded) {
                final comic = state.comic;
                final caseComic = state.caseComic;
                if (comic != AppConstant.comicNotExist) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        floating: false,
                        snap: false,
                        pinned: true,
                        expandedHeight: SizeConfig.screenHeight / 4,
                        flexibleSpace: FlexibleSpaceBar(
                          // title: Align(
                          //     alignment: Alignment.bottomCenter,
                          //     child: Text(
                          //         comic.title != null ? '${comic.title}' : "",
                          //         style: const TextStyle(
                                    
                          //           fontSize: 30,
                          //           fontWeight: FontWeight.bold
                          //         ),
                          //         )),
                          background: comic.image_detail_path != null
                              ? CachedNetworkImage(
                                  imageUrl: comic.image_detail_path!,
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          "assets/images/banner_splash.png"),
                                )
                              : Image.asset("assets/images/banner_splash.png"),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            TabBar(
                              controller: _tabController,
                              tabs: tabs,
                              unselectedLabelColor: Colors.black,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.8,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.screenHeight / 42),
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.screenWidth / 18),
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Infor(
                                      comic: comic,
                                      caseComic: caseComic,
                                    ),
                                    ListChapter(
                                      comic: comic,
                                      caseComic: caseComic,
                                    ),
                                  ],
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
              return const Text(
                "This Comic not found",
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
    );
  }
}
