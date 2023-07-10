import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_constant.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/comic_repository.dart';

part 'view_more_event.dart';

part 'view_more_state.dart';

class ViewMoreBloc extends Bloc<ViewMoreEvent, ViewMoreState> {
  final ComicRepo _comicRepo;

  ViewMoreBloc({required ComicRepo comicRepo})
      : _comicRepo = comicRepo,
        super(ViewMoreInitial()) {
    on<LoadNewComicsViewMore>(_onLoadNewComicsViewMore);
  }

  Future<void> _onLoadNewComicsViewMore(
    LoadNewComicsViewMore event,
    Emitter<ViewMoreState> emit,
  ) async {
    emit(ViewMoreLoading());
    List<Comic> listNewComicsViewMore = [];
    listNewComicsViewMore = await _comicRepo.readNewComicsFromDB(
        limit: AppConstant.limitSeeMoreComic);
    if (listNewComicsViewMore.isEmpty) {
      await _comicRepo.fetchAPINewComics(limit: AppConstant.limitSeeMoreComic);
      listNewComicsViewMore = await _comicRepo.readNewComicsFromDB(
          limit: AppConstant.limitSeeMoreComic);
      if (listNewComicsViewMore.isNotEmpty) {
        emit(ViewMoreLoaded(listNewComicsViewMore));
      } else {
        emit(ViewMoreLoadError());
      }
    } else {
      emit(ViewMoreLoaded(listNewComicsViewMore));
      await _comicRepo
          .fetchAPINewComics(limit: AppConstant.limitSeeMoreComic)
          .whenComplete(() async {
        await Future.delayed(const Duration(seconds: 1), () async {
          listNewComicsViewMore = await _comicRepo.readNewComicsFromDB(
              limit: AppConstant.limitSeeMoreComic);
          emit(ViewMoreLoaded(listNewComicsViewMore));
        });
      });
    }
  }
}
