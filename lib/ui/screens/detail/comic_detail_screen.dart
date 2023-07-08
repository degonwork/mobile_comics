import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/app_color.dart';
import '../../../ui/widgets/build_ads_banner.dart';
import '../../../blocs/case/case_bloc.dart';
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
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height70),
            child: BlocBuilder<ComicDetailBloc, ComicDetailState>(
              builder: (context, state) {
                if (state is ComicDetailLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
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
                          expandedHeight: SizeConfig.height180,
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
                              SizedBox(
                                height: SizeConfig.height45,
                                child: TabBar(
                                  indicatorColor:
                                      AppColor.brownColor.withOpacity(0.2),
                                  indicatorWeight: SizeConfig.width1,
                                  controller: _tabController,
                                  tabs: tabs,
                                  unselectedLabelColor:
                                      AppColor.unSelectTitleColor,
                                  labelColor: AppColor.selectTitleColor,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.height435,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: SizeConfig.height5),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.width15,
                                  ),
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
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              },
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.height10, left: SizeConfig.width20),
              child: const BannerAD()),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height35),
            child: NavigatorButtonScreen(
                icon: Icons.arrow_back_ios_outlined,
                onTap: () {
                  Navigator.pushNamed(context, RouterScreen.routeName);
                  context.read<CaseBloc>().add(const LoadCaseComic());
                }),
          ),
        ],
      ),
    );
  }
}
