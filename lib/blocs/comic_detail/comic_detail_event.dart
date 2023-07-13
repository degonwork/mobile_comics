part of 'comic_detail_bloc.dart';

abstract class ComicDetailEvent extends Equatable {
  const ComicDetailEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LoadDetailComic extends ComicDetailEvent {
  final String id;
  final bool isBack;
  const LoadDetailComic(this.id, this.isBack);
  @override
  List<Object> get props => [id, isBack];
}

class SetStateComicDetailIndex extends ComicDetailEvent {
  final int index;
  const SetStateComicDetailIndex(this.index);
  @override
  List<Object> get props => [index];
}
