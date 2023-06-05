import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/case/case_bloc.dart';
import 'package:full_comics_frontend/ui/widgets/back_ground_app.dart';
import '../../../config/size_config.dart';
import 'widgets/favorite.dart';
import 'widgets/read_offline.dart';
import 'widgets/reading.dart';

class CaseScreen extends StatefulWidget {
  const CaseScreen({super.key});

  @override
  State<CaseScreen> createState() => _CaseScreenState();
}

class _CaseScreenState extends State<CaseScreen>
    with SingleTickerProviderStateMixin {
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Đang đọc'),
    Tab(
      text: 'Yêu thích',
    ),
    Tab(
      text: 'Đọc offline',
    ),
  ];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CaseBloc>(context).add(const LoadCaseComic());
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          const BackGroundApp(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  tabs: tabs,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const ClampingScrollPhysics(),
                    controller: _tabController,
                    children: const [
                      Reading(),
                      Favourite(),
                      ReadOffline(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
