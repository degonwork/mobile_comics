import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/data/repository/ads_repository.dart';
import '../../screens/view_more/new_comics_view_more/new_comics_view_more/new_comics_view_more_screen.dart';
import '../../screens/home/widgets/banner_listview.dart';
import '../../../blocs/view_more/view_more_bloc.dart';
import '../../../config/size_config.dart';
import '../../widgets/back_ground_app.dart';
import '../../widgets/build_ads_banner.dart';
import 'widgets/new_comic.dart';
import 'widgets/select_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ADSRepo.loadADS();
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.height45),
            child: Column(
              children: [
                const BannerAD(),
                SizedBox(height: SizeConfig.height15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const BannerListview(),
                        SizedBox(height: SizeConfig.height20),
                        BlocBuilder<ViewMoreBloc, ViewMoreState>(
                          builder: (context, state) {
                            return SelectTitle(
                              title: AppLocalizations.of(context)!.newComics,
                              press: () {
                                Navigator.pushNamed(
                                    context, NewComicViewMoreScreen.routeName);
                              },
                            );
                          },
                        ),
                        SizedBox(height: SizeConfig.height15),
                        const NewComic(),
                        SizedBox(height: SizeConfig.height20),
                      ],
                    ),
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
