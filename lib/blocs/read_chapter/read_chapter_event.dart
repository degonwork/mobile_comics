import 'package:equatable/equatable.dart';

import '../../data/models/case_comic_model.dart';

abstract class ReadChapterEvent extends Equatable {
  const ReadChapterEvent();
  @override
  List<Object> get props => [];
}

class LoadChapter extends ReadChapterEvent {
  final String chapterId;
  const LoadChapter(this.chapterId);
  @override
  List<Object> get props => [chapterId];
}

class LoadNextChapter extends ReadChapterEvent {
  final String comicId;
  final int chapterIndex;
  const LoadNextChapter(this.comicId, this.chapterIndex);
  @override
  List<Object> get props => [comicId, chapterIndex];
}

class SetStateButtonBackIndex extends ReadChapterEvent {
  final bool visialbe;
  const SetStateButtonBackIndex(this.visialbe);
  @override
  List<Object> get props => [visialbe];
}

class ContinueReading extends ReadChapterEvent {
  final CaseComic caseComic;
  const ContinueReading(this.caseComic);
  @override
  List<Object> get props => [caseComic];
}

class ContinueFailed extends ReadChapterEvent {}
