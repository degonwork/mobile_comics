import 'package:flutter/material.dart';
import '../../../config/app_color.dart';
import '../../../config/size_config.dart';
import '../../widgets/back_ground_app.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.height45),
            child: Column(
              children: [
                TabBar(
                  indicatorColor: AppColor.brownColor.withOpacity(0.2),
                  indicatorWeight: SizeConfig.width1,
                  controller: _tabController,
                  labelColor: AppColor.selectTitleColor,
                  tabs: tabs,
                  unselectedLabelColor: AppColor.unSelectTitleColor,
                ),
                SizedBox(height: SizeConfig.height20),
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
