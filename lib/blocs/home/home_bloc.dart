import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
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
      print("Comic DB is empty");
      await _comicRepo.fetchApiAndCreateDBHomeComic();
      listHotComics = await _comicRepo.readHotComicsFromDB(
          limit: AppConstant.limitHomeComic);
      listNewComics = await _comicRepo.readNewComicsFromDB(
          limit: AppConstant.limitHomeComic);
      emit(HomeLoaded(listHotComics, listNewComics));
    } else {
      print("Comic DB is not empty");
      listNewComics = await _comicRepo.readNewComicsFromDB(
          limit: AppConstant.limitHomeComic);
      emit(HomeLoaded(listHotComics, listNewComics));
      // await _comicRepo.fetchApiAndCreateDBHomeComic().whenComplete(() async {
      //   await Future.delayed(const Duration(seconds: 1), () async {
      //     listHotComics = await _comicRepo.readHotComicsFromDB(
      //         limit: AppConstant.limitHomeComic);
      //     listNewComics = await _comicRepo.readNewComicsFromDB(
      //         limit: AppConstant.limitHomeComic);
      //     emit(HomeLoaded(listHotComics, listHotComics));
      //   });
      // });
    }
  }
}
