part of 'comic_detail_bloc.dart';

abstract class ComicDetailState extends Equatable {
  const ComicDetailState();

  @override
  List<Object> get props => [];
}

class ComicDetailInitial extends ComicDetailState {}

class ComicDetailLoading extends ComicDetailState {}

class ComicDetailLoaded extends ComicDetailState {
  final Comic comic;
  final CaseComic caseComic;
  final int index;
  const ComicDetailLoaded(this.comic, this.caseComic, this.index);
  @override
  List<Object> get props => [comic, caseComic, index];
}

class ComicDetailLoadError extends ComicDetailState {}
