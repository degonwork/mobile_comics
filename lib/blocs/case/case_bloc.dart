import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repository/comic_repository.dart';
import '../../data/models/case_comic_model.dart';
part 'case_event.dart';
part 'case_state.dart';

class CaseBloc extends Bloc<CaseEvent, CaseState> {
  final ComicRepo _comicRepo;

  CaseBloc({
    required ComicRepo comicRepo,
  })  : _comicRepo = comicRepo,
        super(CaseInitial()) {
    on<AddCaseComic>(_onAddCaseComic);
    on<LoadCaseComic>(_onLoadCaseComic);
  }

  Future<void> _onAddCaseComic(
      AddCaseComic event, Emitter<CaseState> emit) async {
    await _comicRepo.addCaseComic(
      comicId: event.comicId,
      chapterId: event.chapterId,
      numericChapter: event.numericChapter,
      imageThumnailSquareComicPath: event.imageThumnailSquareComicPath,
      titleComic: event.titleComic,
      reads: event.reads,
    );
    add(const LoadCaseComic());
  }

  Future<void> _onLoadCaseComic(
      LoadCaseComic event, Emitter<CaseState> emit) async {
    emit(CaseLoading());
    final sharedPreferences = await SharedPreferences.getInstance();
    List<CaseComic> listCaseComicLocal = [];
    listCaseComicLocal =
        await _comicRepo.getListCaseComicFromLocal(sharedPreferences);
    if (listCaseComicLocal.isNotEmpty) {
      emit(CaseLoaded(listCaseComicLocal.reversed.toList()));
    } else {
      emit(CaseLoadError());
    }
  }
}
