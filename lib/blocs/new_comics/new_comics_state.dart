part of 'new_comics_bloc.dart';

abstract class NewComicsState extends Equatable {
  const NewComicsState();

  @override
  List<Object> get props => [];
}

class NewComicsInitial extends NewComicsState {}

class NewComicsLoaded extends NewComicsState {
  const NewComicsLoaded(
    this.listNewComics,
  );
  final List<Comic> listNewComics;

  @override
  List<Object> get props => [listNewComics];
}

class NewComicsFailed extends NewComicsState {}
