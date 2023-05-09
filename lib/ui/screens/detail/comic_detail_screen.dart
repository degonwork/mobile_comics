import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/comic_detail/comic_detail_bloc.dart';
import '../detail/widgets/chapter.dart';
// import '../detail/widgets/comment.dart';
import '../detail/widgets/infor.dart';
import '../../../config/size_config.dart';

class ComicDetailScreen extends StatefulWidget {
  const ComicDetailScreen({super.key});
  static const String routeName = '/comic-detail';

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen>
    with SingleTickerProviderStateMixin {
  
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Thông tin'),
    Tab(text: 'Chương'),
    // Tab(text: 'Bình luận'),
  ];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<ComicDetailBloc, ComicDetailState>(
      builder: (context, state) {
        if (state is ComicDetailLoaded) {
          final comic = state.comic;
print(comic.image_thumnail_square_path);
          return Scaffold(
            body: Container(
              height: SizeConfig.screenHeight,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.yellow,
                  Colors.cyan,
                  Colors.indigo,
                ],
                begin: Alignment.topCenter,
                end: AlignmentDirectional.bottomCenter,
              )),
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    floating: false,
                    snap: false,
                    pinned: true,
                    expandedHeight: SizeConfig.screenHeight / 4,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(comic.title!)),
                      background: CachedNetworkImage(
                        imageUrl: comic.image_thumnail_square_path!,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill),
                            ),
                          );
                        },
                        placeholder: (context,url) => const CircularProgressIndicator(),
                        // errorWidget: (context,url,error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
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
                            children: const [
                              Infor(),
                              ListChapter(),
                              // Comment(),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
