import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';
part 'comic_detail_event.dart';
part 'comic_detail_state.dart';

class ComicDetailBloc extends Bloc<ComicDetailEvent, ComicDetailState> {
  final ComicRepo _comicRepo;
  ComicDetailBloc({required ComicRepo comicRepo})
      : _comicRepo = comicRepo,
        super(ComicDetailInitial()) {
    on<LoadDetailComic>(_onLoadComicDetail);
  }
  Future<void> _onLoadComicDetail(
    LoadDetailComic event,
    Emitter<ComicDetailState> emit,
  ) async {
    // print(event.id);
    Comic comic = await _comicRepo.fetchDetailComics(id: event.id);
    emit(ComicDetailLoaded(comic));
  }
}
