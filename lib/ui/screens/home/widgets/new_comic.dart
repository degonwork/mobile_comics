import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../../../blocs/home/home_bloc.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/gridview_comics.dart';

class NewComic extends StatelessWidget {
  const NewComic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final listNewComics = state.lisNewComics;
          if (listNewComics.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width15,
              ),
              child: GridviewComics(listComics: listNewComics),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: AppColor.circular));
          }
        }
        return const Center(
            child: CircularProgressIndicator(color: AppColor.circular));
      },
    );
  }
}
