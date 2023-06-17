import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
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
    emit(const ComicDetailLoaded(
        AppConstant.comicNotExist, AppConstant.caseComicNotExist));
    try {
      Comic comic = await _comicRepo.fetchDetailComics(id: event.id);
      CaseComic? caseComic = await _comicRepo.getCaseComicFromLocal(comic.id);
      emit(ComicDetailLoaded(comic, caseComic));
    } catch (e) {
      emit(ComicDetailLoadFailed());
    }
  }
}
