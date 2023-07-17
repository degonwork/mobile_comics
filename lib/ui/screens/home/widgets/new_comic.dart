import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../ui/screens/router/router_screen.dart';
import '../../../../blocs/router/router_bloc.dart';
import '../../../../ui/widgets/text_ui.dart';
import '../../../../config/app_color.dart';
import '../../../../blocs/home/home_bloc.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/gridview_comics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewComic extends StatelessWidget {
  const NewComic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColor.circular));
        }
        if (state is HomeLoaded) {
          final listNewComics = state.lisNewComics;
          if (listNewComics.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width15),
              child: GridviewComics(
                listComics: listNewComics,
                routerNameTap: () {
                  context.read<RouterBloc>().add(
                        const SetRouterScreen(RouterScreen.routeName),
                      );
                },
              ),
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
    );
  }
}
