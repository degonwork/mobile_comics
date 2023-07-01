import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/case_comic_model.dart';
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
    emit(ComicDetailLoading());
    Comic comic = await _comicRepo.readComicDetailFromDB(id: event.id);
    CaseComic? caseComic = await _comicRepo.getCaseComicFromLocal(comic.id);
    if (comic.isFull == 0) {
      print("Comic not full ----------------------------");
      await _comicRepo.fetchDetailComics(id: event.id, isUpdate: true);
      comic = await _comicRepo.readComicDetailFromDB(id: event.id);
      emit(ComicDetailLoaded(comic, caseComic));
    } else {
      print("Comic is full--------------------------------");
      emit(ComicDetailLoaded(comic, caseComic));
      await _comicRepo
          .fetchDetailComics(id: event.id, isUpdate: true)
          .whenComplete(() async {
        await Future.delayed(const Duration(seconds: 1), () async {
          comic = await _comicRepo.readComicDetailFromDB(id: event.id);
          emit(ComicDetailLoaded(comic, caseComic));
        });
      });
    }
  }
}
