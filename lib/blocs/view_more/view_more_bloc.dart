import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    List<Comic> listNewComicsViewMore =
        await _comicRepo.readNewComicsFromDB(limit: 20);
    emit(ViewMoreLoaded(listNewComicsViewMore));
  }
}
