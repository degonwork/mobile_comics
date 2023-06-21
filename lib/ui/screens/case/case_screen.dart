import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/case/case_bloc.dart';
import 'package:full_comics_frontend/ui/widgets/back_ground_app.dart';
import '../../../config/size_config.dart';
import 'widgets/favorite.dart';
import 'widgets/read_offline.dart';
import 'widgets/reading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CaseScreen extends StatefulWidget {
  const CaseScreen({super.key});

  @override
  State<CaseScreen> createState() => _CaseScreenState();
}

class _CaseScreenState extends State<CaseScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CaseBloc>(context).add(const LoadCaseComic());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(text: AppLocalizations.of(context)!.reading),
      Tab(
        text: AppLocalizations.of(context)!.favourite,
      ),
      Tab(
        text: AppLocalizations.of(context)!.offline,
      ),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.height45),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  tabs: tabs,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: SizeConfig.font16,
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
      ),
    );
  }
}
