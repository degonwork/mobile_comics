import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/ui/screens/search_screen/search_screen.dart';
// import 'package:full_comics_frontend/ui/screens/search_screen/search_screen.dart';

import '../../../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../../../blocs/search_bloc/search_bloc.dart';
import '../../../../blocs/search_bloc/search_event.dart';
import '../../../../blocs/search_bloc/search_state.dart';
import '../../../../config/size_config.dart';
import '../../detail/comic_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: SizeConfig.screenWidth / 18),
              child: Column(
                children: [
                  TextField(
                    onChanged: (title){
                      context.read<SearchBloc>().add(SearchByTitle(title: title));
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:   Colors.blue.withOpacity(0.2),
                      hintText: "Tìm kiếm truyện , thể loại ...",
                      prefixIcon: const Icon(Icons.search),
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight / 50.4,),
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context,state){
                      if (state is SearchLoading) {
                        return const CircularProgressIndicator();
                      } else if(state is SearchLoaded){
                        final comics = state.comics;
                        if (comics.isNotEmpty) {
                          return SizedBox(
                            height: SizeConfig.screenHeight / 10,
                            child: ListView.builder(
                              shrinkWrap: true,
                              cacheExtent: 10,
                              itemCount: comics.length,
                              itemBuilder: (context,index){
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow:  [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset:  const Offset(0, 3), 
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context.read<ComicDetailBloc>().add(LoadDetailComic(comics[index].id));
                                      Navigator.pushNamed(context, ComicDetailScreen.routeName);
                                    },
                                    child: SizedBox(
                                      height: SizeConfig.screenHeight / 20,
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        children: [
                                          comics[index].image_thumnail_square_path != null ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            height: SizeConfig.screenHeight / 15.12,
                                            width: SizeConfig.screenWidth /7.2,
                                            
                                            child: CachedNetworkImage(
                                              imageUrl: comics[index].image_thumnail_square_path!,
                                              fit: BoxFit.fill,
                                              ),
                                          ): const CircularProgressIndicator(),
                                          SizedBox(width: SizeConfig.screenWidth / 20,),  
                                          comics[index].title != null ? Text(comics[index].title!) : const Text(""),  
                                          
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                          );
                        }
                      }else if(state is SearchFailure){
                        return const Text("Không tìm thấy truyện phù hợp");
                      }
                      return const SizedBox();
                    }
                    
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const  SearchComicScreen()));
                  }, child: Text('CHUYEN')),
                ],
              ),
    );
  }
}