import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_constant.dart';
import '../../data/models/comic_model.dart';
import '../../data/repository/comic_repository.dart';
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
    LoadHomeComic event,
    Emitter<HomeState> emit,
  ) async {
    try {
      List<Comic> listHotComics = await _comicRepo.fetchAPIAndCreateDBHotComics(
          limit: AppConstant.limitHomeComic);
      List<Comic> listNewComics = await _comicRepo.fetchAPIAndCreateDBNewComics(
          limit: AppConstant.limitSeeMoreComic);
      emit(
        HomeLoaded(listHotComics, listNewComics),
      );
    } catch (e) {
      emit(HomeFailed());
    }
  }
}
