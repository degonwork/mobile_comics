import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_event.dart';
import 'package:full_comics_frontend/blocs/search_comic_bloc/search_comic_state.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';

class SearchComicBloc extends Bloc<SearchComicEvent,SearchComicState> {
  final ComicRepo _comicRepo;
   SearchComicBloc({required ComicRepo comicRepo}) : _comicRepo = comicRepo,super(SearchInitial()){
   on<SearchByQuery>(_onSearchByQuery);
   }
   Future<void> _onSearchByQuery(SearchByQuery event,Emitter<SearchComicState> emitter)async{
    emitter(SearchLoading());
    try {
      final comicResult = await _comicRepo.searchComic(event.query);
      emitter(SearchLoadded(comicResult));
    } catch (e) {
      emitter(SearchError());
    }
   }
}