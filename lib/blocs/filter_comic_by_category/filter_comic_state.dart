import 'package:equatable/equatable.dart';

import '../../data/models/comic_model.dart';

abstract class FilterComicState extends Equatable {
  const FilterComicState();
  @override
  List<Object> get props => [];
}

class FilterComicInital extends FilterComicState {}

class ComicByCategoryLoading extends FilterComicState {}

class ComicByCategoryLoaded extends FilterComicState {
  final List<Comic> listComics;
  const ComicByCategoryLoaded(this.listComics);
  @override
  List<Object> get props => [listComics];
}
