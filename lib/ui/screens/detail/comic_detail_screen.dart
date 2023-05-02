import 'package:flutter/material.dart';
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
  String? title;
  String? urlImage;
  int? chapNumber;
  List<String>? type;
  String? summary;
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
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              floating: false,
              snap: false,
              pinned: true,
              expandedHeight: SizeConfig.screenHeight / 4,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "state.detailComic!.title",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://i.pinimg.com/564x/47/9a/90/479a903a36d2805eef7e71d8e7a0b774.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                      margin:
                          EdgeInsets.only(top: SizeConfig.screenHeight / 42),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
