import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/data/models/case_comic_model.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/comic_repository.dart';
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
    try {
      Comic comic = await _comicRepo.readComicDetailFromDB(id: event.id);
      CaseComic? caseComic = await _comicRepo.getCaseComicFromLocal(comic.id);
      emit(ComicDetailLoaded(comic, caseComic));
      // await _comicRepo.fetchDetailComics(id: event.id).whenComplete(() async {
      //   Comic comicsResult = await _comicRepo.readComicDetail(id: event.id);
      //   emit(ComicDetailLoaded(comicsResult, caseComic));
      // });
    } catch (e) {
      emit(ComicDetailLoadFailed());
    }
  }
}
