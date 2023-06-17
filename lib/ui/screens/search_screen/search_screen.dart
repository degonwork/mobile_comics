// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_bloc.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_event.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_state.dart';
import 'package:full_comics_frontend/ui/widgets/back_ground_app.dart';
// import 'package:full_comics_frontend/ui/screens/detail/widgets/descreption.dart';
// import 'package:full_comics_frontend/config/ui_constant.dart';

import '../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../config/size_config.dart';
import '../../../config/ui_constant.dart';
import '../detail/comic_detail_screen.dart';

class SearchComicScreen extends StatelessWidget {
  const SearchComicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.7),
        title: Container(
          width: double.infinity,
          height: SizeConfig.screenHeight / 15.12,
          decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.7),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: TextField(
              style: const TextStyle(color: Colors.black),
              onChanged: (query) {
                context.read<SearchComicBloc>().add(SearchByQuery(query));
              },
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black.withOpacity(0.8),
                ),
                hintText: "Nhập từ khóa để tìm kiếm ...",
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const BackGroundApp(),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.screenHeight / 37.8),
            child: BlocBuilder<SearchComicBloc, SearchComicState>(
                builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchLoadded) {
                final listComics = state.listComics;
                if (listComics.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth / 18),
                    child: ListView.builder(
                        shrinkWrap: true,
                        cacheExtent: 10,
                        itemCount: listComics.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                // Text('Kết quả tìm kiếm cho từ khóa ${}',style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                                SizedBox(
                                  height: SizeConfig.screenHeight / 37.8,
                                ),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<ComicDetailBloc>()
                                        .add(LoadDetailComic(listComics[index].id));
                                    Navigator.pushNamed(
                                        context, ComicDetailScreen.routeName);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.03)),
                                        ]),
                                    height: SizeConfig.screenHeight / 8.4,
                                    child: Row(
                                      children: [
                                        listComics[index]
                                                    .image_thumnail_square_path !=
                                                null
                                            ? Expanded(
                                                flex: 9,
                                                child: Container(
                                                  padding: EdgeInsets.zero,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(10)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              listComics[index]
                                                                  .image_thumnail_square_path!),
                                                          fit: BoxFit.fill)),
                                                  height:
                                                      SizeConfig.screenHeight / 8.4,
                                                  width: SizeConfig.screenWidth / 4,
                                                  // child: CachedNetworkImage(
                                                  //   imageUrl: listComics[index]
                                                  //       .image_thumnail_square_path!,
                                                  //   fit: BoxFit.fill,
                                                  // ),
                                                ),
                                              )
                                            : const CircularProgressIndicator(),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: SizeConfig.screenWidth / 20,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 24,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              listComics[index].title != null
                                                  ? Expanded(
                                                      child: Text(
                                                      listComics[index].title!,
                                                      style: titleComic,
                                                    ))
                                                  : const Text(""),
                                              const SizedBox(),
                                              listComics[index].description != null
                                                  ? Expanded(
                                                      child: Text(
                                                        listComics[index]
                                                            .description!,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  : const Text(""),
                                            ],
                                          ),
                                        ),

                                        
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight / 37.8,
                                )
                              ],
                            ),
                          );
                        }),
                  );
                }
              } else if (state is SearchError) {
                return const Text('Không tìm thấy truyện phù hợp');
              }
              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }
}
