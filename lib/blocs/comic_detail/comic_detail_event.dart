part of 'comic_detail_bloc.dart';

abstract class ComicDetailEvent extends Equatable {
  const ComicDetailEvent();

  @override
  List<Object> get props => [];
}
class LoadDetailComic extends ComicDetailEvent{
  final String id;

  const LoadDetailComic(this.id);
  @override
  List<Object> get props => [id];
}