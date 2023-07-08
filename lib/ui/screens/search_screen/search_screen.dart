import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../blocs/search_comic/search_comic_bloc.dart';
import '../../../blocs/search_comic/search_comic_event.dart';
import '../../../blocs/search_comic/search_comic_state.dart';
import '../../../config/size_config.dart';
import '../../widgets/back_ground_app.dart';
import '../../widgets/text_ui.dart';
import '../detail/comic_detail_screen.dart';

class SearchComicScreen extends StatelessWidget {
  const SearchComicScreen({super.key});
  static const String routeName = '/search-comic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.7),
        title: Container(
          width: double.infinity,
          height: SizeConfig.screenHeight / 15.12,
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: TextField(
              style: const TextStyle(color: Colors.black),
              onChanged: (query) {
                context.read<SearchComicBloc>().add(SearchByQuery(query));
              },
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: AppLocalizations.of(context)!.keywords,
                hintStyle: const TextStyle(color: Colors.black),
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
                                SizedBox(
                                  height: SizeConfig.screenHeight / 37.8,
                                ),
                                InkWell(
                                  onTap: () {
                                    context.read<ComicDetailBloc>().add(
                                        LoadDetailComic(listComics[index].id));
                                    Navigator.pushNamed(
                                        context, ComicDetailScreen.routeName);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.white
                                                  .withOpacity(0.03)),
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
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              listComics[index]
                                                                  .image_thumnail_square_path!),
                                                          fit: BoxFit.fill)),
                                                  height:
                                                      SizeConfig.screenHeight /
                                                          8.4,
                                                  width:
                                                      SizeConfig.screenWidth /
                                                          4,
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
                                            children: [
                                              Expanded(
                                                child: TextUi(
                                                  textAlign: TextAlign.start,
                                                  text: listComics[index].title,
                                                  fontSize: SizeConfig.font20,
                                                ),
                                              ),
                                              const SizedBox(),
                                              Expanded(
                                                child: TextUi(
                                                  textAlign: TextAlign.start,
                                                  text: listComics[index]
                                                      .description,
                                                  maxLines: 2,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
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
              }
              return Container(
                  padding: EdgeInsets.only(left: SizeConfig.width15),
                  child: Text(
                    AppLocalizations.of(context)!.notFound,
                    style: TextStyle(
                        color: Colors.white, fontSize: SizeConfig.font16),
                  ));
            }),
          ),
        ],
      ),
    );
  }
}
