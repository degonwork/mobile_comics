import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_constant.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/comic_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ComicRepo _comicRepo;

  HomeBloc({required ComicRepo comicRepo})
      : _comicRepo = comicRepo,
        super(HomeInitial()) {
    on<LoadHomeComic>(_onLoadHomeComic);
  }

  Future<void> _onLoadHomeComic(
      LoadHomeComic event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    List<Comic> listHotComics = [];
    List<Comic> listNewComics = [];
    listHotComics =
        await _comicRepo.readHotComicsFromDB(limit: AppConstant.limitHomeComic);
    if (listHotComics.isEmpty) {
      try {
        await _comicRepo.fetchApiHomeComic(isUpdate: false);
        listHotComics = await _comicRepo.readHotComicsFromDB(
            limit: AppConstant.limitHomeComic);
        listNewComics = await _comicRepo.readNewComicsFromDB(
            limit: AppConstant.limitHomeComic);
        emit(HomeLoaded(listHotComics, listNewComics));
      } catch (e) {
        emit(HomeLoadError());
      }
    } else {
      listNewComics = await _comicRepo.readNewComicsFromDB(
          limit: AppConstant.limitHomeComic);
      emit(HomeLoaded(listHotComics, listNewComics));
      await _comicRepo.fetchApiHomeComic(isUpdate: true).whenComplete(() async {
        await Future.delayed(const Duration(seconds: 1), () async {
          listHotComics = await _comicRepo.readHotComicsFromDB(
              limit: AppConstant.limitHomeComic);
          listNewComics = await _comicRepo.readNewComicsFromDB(
              limit: AppConstant.limitHomeComic);
          emit(HomeLoaded(listHotComics, listNewComics));
        });
      });
    }
  }
}
