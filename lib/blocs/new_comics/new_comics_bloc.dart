import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/comic_repository.dart';
part 'new_comics_event.dart';
part 'new_comics_state.dart';

class NewComicsBloc extends Bloc<NewComicsEvent, NewComicsState> {
  final ComicRepo _comicRepo;
  NewComicsBloc({required ComicRepo comicRepo})
      : _comicRepo = comicRepo,
        super(NewComicsInitial()) {
    on<LoadNewComics>(_onLoadNewComics);
  }

  Future<void> _onLoadNewComics(
      LoadNewComics event, Emitter<NewComicsState> emit) async {
    try {
      List<Comic> listNewComics = await _comicRepo.readNewComicsFromDB(
          limit: AppConstant.limitHomeComic);
      if (listNewComics.isEmpty) {
        await _comicRepo.fetchAPIAndCreateDBNewComics(
            limit: AppConstant.limitHomeComic);
        List<Comic> newComicsResult = await _comicRepo.readNewComicsFromDB(
            limit: AppConstant.limitHomeComic);
        emit(NewComicsLoaded(newComicsResult));
      } else {
        emit(NewComicsLoaded(listNewComics));
        // await _comicRepo
        //     .fetchAPIAndCreateDBNewComics(limit: AppConstant.limitHomeComic)
        //     .whenComplete(
        //   () async {
        //     List<Comic> newComicsResult = await _comicRepo.readNewComicsFromDB(
        //         limit: AppConstant.limitHomeComic);
        //     emit(NewComicsLoaded(newComicsResult));
        //   },
        // );
      }
    } catch (e) {
      emit(NewComicsFailed());
    }
  }
}
