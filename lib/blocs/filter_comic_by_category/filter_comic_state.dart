import 'package:equatable/equatable.dart';

import '../../data/models/comic_model.dart';

abstract class FilterComicState extends Equatable {
  const FilterComicState();
  @override
  List<Object> get props => [];
}

class FilterComicInital extends FilterComicState {}

class LoadingComicByCategory extends FilterComicState {}

class LoadedComicByCategoryID extends FilterComicState {
  final List<Comic> listComics;
  const LoadedComicByCategoryID(this.listComics);
  @override
  List<Object> get props => [listComics];
}

class FilterComicFailed extends FilterComicState {}
