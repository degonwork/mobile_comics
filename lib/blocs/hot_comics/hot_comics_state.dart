part of 'hot_comics_bloc.dart';

abstract class HotComicsState extends Equatable {
  const HotComicsState();

  @override
  List<Object> get props => [];
}

class HotComicsInitial extends HotComicsState {}

class HotComicsLoaded extends HotComicsState {
  final List<Comic> listHotComics;

  const HotComicsLoaded(
    this.listHotComics,
  );

  @override
  List<Object> get props => [listHotComics];
}

class HotComicsFailed extends HotComicsState {}
