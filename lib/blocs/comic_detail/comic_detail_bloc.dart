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
    on<SetStateComicDetailIndex>(_onSetStateComicDetailIndex);
  }

  Future<void> _onLoadComicDetail(
    LoadDetailComic event,
    Emitter<ComicDetailState> emit,
  ) async {
    int index = 0;
    if (state is ComicDetailLoaded && event.isBack == true) {
      if ((state as ComicDetailLoaded).comic.id == event.id) {
        index = (state as ComicDetailLoaded).index;
      } else {
        index = 0;
      }
    }
    emit(ComicDetailLoading());
    Comic comic = await _comicRepo.readComicDetailFromDB(id: event.id);
    CaseComic caseComic = await _comicRepo.getCaseComicFromLocal(comic.id);
    if (comic.isFull == 0) {
      try {
        await _comicRepo.fetchDetailComics(id: event.id, isUpdate: true);
        comic = await _comicRepo.readComicDetailFromDB(id: event.id);
        emit(ComicDetailLoaded(comic, caseComic, index));
      } catch (e) {
        emit(ComicDetailLoadError());
      }
    } else {
      emit(ComicDetailLoaded(comic, caseComic, index));
      await _comicRepo
          .fetchDetailComics(id: event.id, isUpdate: true)
          .whenComplete(() async {
        await Future.delayed(const Duration(seconds: 1), () async {
          comic = await _comicRepo.readComicDetailFromDB(id: event.id);
          if (state is ComicDetailLoaded) {
            emit(
              ComicDetailLoaded(
                comic,
                caseComic,
                (state as ComicDetailLoaded).index,
              ),
            );
          }
        });
      });
    }
  }

  void _onSetStateComicDetailIndex(
      SetStateComicDetailIndex event, Emitter<ComicDetailState> emit) {
    if (state is ComicDetailLoaded) {
      emit(ComicDetailLoaded((state as ComicDetailLoaded).comic,
          (state as ComicDetailLoaded).caseComic, event.index));
    }
  }
}
