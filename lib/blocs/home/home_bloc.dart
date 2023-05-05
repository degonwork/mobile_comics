import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ComicRepo _comicRepo;
  HomeBloc({
    required ComicRepo comicRepo,
  })  : _comicRepo = comicRepo,
        super(HomeInitial()) {
    on<LoadHomeComic>(_onLoadHomeComic);
  }
  Future<void> _onLoadHomeComic(
    LoadHomeComic evemt,
    Emitter<HomeState> emit,
  ) async {
    print("Hot Comics");
    List<HomeComic>? listHotComics =
        await _comicRepo.fetchAPIAndCreateDBHotComics(limit: AppConstant.LIMIT);
    print("New Comics");
    List<HomeComic>? listNewComics =
        await _comicRepo.fetchAPIAndCreateDBNewComics(limit: AppConstant.LIMIT);
    emit(HomeLoaded(
        listHotComics: listHotComics!, listNewComics: listNewComics!));
  }
}
