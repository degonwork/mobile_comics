import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_constant.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/comic_repository.dart';
part 'hot_comics_event.dart';
part 'hot_comics_state.dart';

class HotComicsBloc extends Bloc<HotComicsEvent, HotComicsState> {
  final ComicRepo _comicRepo;
  HotComicsBloc({required ComicRepo comicRepo})
      : _comicRepo = comicRepo,
        super(HotComicsInitial()) {
    on<LoadHotComics>(_onLoadHotComics);
  }

  Future<void> _onLoadHotComics(
      LoadHotComics event, Emitter<HotComicsState> emit) async {
    try {
      List<Comic> listHotComics = await _comicRepo.readHotComicsFromDB(
          limit: AppConstant.limitHomeComic);
      if (listHotComics.isEmpty) {
        await _comicRepo.fetchAPIAndCreateDBHotComics(
            limit: AppConstant.limitHomeComic);
        List<Comic> hotComicsResult = await _comicRepo.readHotComicsFromDB(
            limit: AppConstant.limitHomeComic);
        emit(HotComicsLoaded(hotComicsResult));
      } else {
        emit(HotComicsLoaded(listHotComics));
        // await _comicRepo
        //     .fetchAPIAndCreateDBHotComics(limit: AppConstant.limitHomeComic)
        //     .whenComplete(
        //   () async {
        //     List<Comic> hotComicsResult = await _comicRepo.readHotComicsFromDB(
        //         limit: AppConstant.limitHomeComic);
        //     emit(HotComicsLoaded(hotComicsResult));
        //   },
        // );
      }
    } catch (e) {
      // print(e.toString());
      emit(HotComicsFailed());
    }
  }
}
