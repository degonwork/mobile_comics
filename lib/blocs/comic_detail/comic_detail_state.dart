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
  const ComicDetailLoaded(this.comic, this.caseComic);
  @override
  List<Object> get props => [comic, caseComic];
}

class ComicDetailLoadFailed extends ComicDetailState {}
