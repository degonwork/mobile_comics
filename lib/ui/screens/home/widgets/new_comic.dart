import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/new_comics/new_comics_bloc.dart';
import '../../../../config/size_config.dart';
import '../../../widgets/gridview_comics.dart';

class NewComic extends StatelessWidget {
  const NewComic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewComicsBloc, NewComicsState>(
      builder: (context, state) {
        if (state is NewComicsLoaded) {
          final listNewComics = state.listNewComics;
          if (listNewComics.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width15,
              ),
              child: GridviewComics(listComics: listNewComics),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.amber));
          }
        }
        return const Center(
            child: CircularProgressIndicator(color: Colors.amber));
      },
    );
  }
}
