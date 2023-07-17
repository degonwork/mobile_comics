import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/router/router_bloc.dart';
import '../../../../ui/widgets/text_ui.dart';
import '../../../../blocs/view_more/view_more_bloc.dart';
import '../../../../config/app_color.dart';
import '../../../widgets/back_ground_app.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/gridview_comics.dart';
import '../../router/router_screen.dart';

class NewComicViewMoreScreen extends StatelessWidget {
  const NewComicViewMoreScreen({super.key});

  static const String routeName = '/new-comics-view-more';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.height45,
              left: SizeConfig.width15,
              right: SizeConfig.width15,
              bottom: SizeConfig.height10,
            ),
            child: Column(
              children: [
                CustomAppbar(
                  text: AppLocalizations.of(context)!.newComics,
                  iconleftWidget: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouterScreen.routeName);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: SizeConfig.icon25,
                      color: AppColor.iconAppbarColor,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.height20),
                BlocBuilder<ViewMoreBloc, ViewMoreState>(
                  builder: (context, state) {
                    if (state is ViewMoreLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.circular,
                        ),
                      );
                    }
                    if (state is ViewMoreLoaded) {
                      final listNewComicsViewMore = state.listNewComicsViewMore;
                      return Expanded(
                        child: GridviewComics(
                          listComics: listNewComicsViewMore,
                          routerNameTap: () {
                            context.read<RouterBloc>().add(
                                  const SetRouterScreen(
                                    NewComicViewMoreScreen.routeName,
                                  ),
                                );
                          },
                        ),
                      );
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
