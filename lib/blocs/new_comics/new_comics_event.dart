part of 'new_comics_bloc.dart';

abstract class NewComicsEvent extends Equatable {
  const NewComicsEvent();

  @override
  List<Object> get props => [];
}

class LoadNewComics extends NewComicsEvent {
  const LoadNewComics();
  @override
  List<Object> get props => [];
}
