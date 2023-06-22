import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/comic_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ComicRepo comicRepo;
  SearchBloc(this.comicRepo) : super(SearchInitial()) {
    on<SearchByTitle>(_onSearchByTitle);
  }
  Future<void> _onSearchByTitle(
      SearchByTitle event, Emitter<SearchState> emitter) async {
    emitter(SearchLoading());
    try {
      final comics = await comicRepo.searchComicByTitle(event.title);
      emitter(SearchLoaded(comics: comics));
    } catch (e) {
      emitter(SearchFailure());
    }
  }
}
