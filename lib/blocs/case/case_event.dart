part of 'case_bloc.dart';

abstract class CaseEvent extends Equatable {
  const CaseEvent();

  @override
  List<Object> get props => [];
}

class AddCaseComic extends CaseEvent {
  final String comicId;
  final String chapterId;
  final String? imageThumnailSquareComicPath;
  final String titleComic;
  final int numericChapter;
  final int reads;
  const AddCaseComic({
    required this.comicId,
    required this.chapterId,
    this.imageThumnailSquareComicPath,
    required this.titleComic,
    required this.numericChapter,
    required this.reads,
  });
  @override
  List<Object> get props => [
        comicId,
        chapterId,
        imageThumnailSquareComicPath!,
        titleComic,
        numericChapter,
        reads
      ];
}

class LoadCaseComic extends CaseEvent {
  const LoadCaseComic();
  @override
  List<Object> get props => [];
}
