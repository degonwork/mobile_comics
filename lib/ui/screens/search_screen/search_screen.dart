import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_bloc.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_event.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_state.dart';

import '../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../config/size_config.dart';
import '../detail/comic_detail_screen.dart';

class SearchComicScreen extends StatelessWidget {
  const SearchComicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            context.read<SearchComicBloc>().add(SearchByQuery(value));
          },
          decoration: const InputDecoration(labelText: "tim kiem"),
        ),
      ),
      body: BlocBuilder<SearchComicBloc, SearchComicState>(
          builder: (context, state) {
        if (state is SearchLoading) {
          return const CircularProgressIndicator();
        } else if (state is SearchLoadded) {
          final listComics = state.listComics;
          if (listComics.isNotEmpty) {
            return SizedBox(
              height: SizeConfig.screenHeight / 10,
              child: ListView.builder(
                  shrinkWrap: true,
                  cacheExtent: 10,
                  itemCount: listComics.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<ComicDetailBloc>()
                              .add(LoadDetailComic(listComics[index].id));
                          Navigator.pushNamed(
                              context, ComicDetailScreen.routeName);
                        },
                        child: SizedBox(
                          height: SizeConfig.screenHeight / 20,
                          width: SizeConfig.screenWidth,
                          child: Row(
                            children: [
                              listComics[index].image_thumnail_square_path != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: SizeConfig.screenHeight / 15.12,
                                      width: SizeConfig.screenWidth / 7.2,
                                      child: CachedNetworkImage(
                                        imageUrl: listComics[index]
                                            .image_thumnail_square_path!,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : const CircularProgressIndicator(),
                              SizedBox(
                                width: SizeConfig.screenWidth / 20,
                              ),
                              listComics[index].title != null
                                  ? Text(listComics[index].title!)
                                  : const Text(""),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
        } else if (state is SearchError) {
          return const Text('Loi tim kiem');
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
