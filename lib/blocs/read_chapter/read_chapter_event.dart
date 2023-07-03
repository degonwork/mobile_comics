import 'package:equatable/equatable.dart';

abstract class ReadChapterEvent extends Equatable {
  const ReadChapterEvent();
  @override
  List<Object> get props => [];
}

class LoadChapter extends ReadChapterEvent {
  final String id;
  const LoadChapter(this.id);
  @override
  List<Object> get props => [id];
}

class LoadNextChapter extends ReadChapterEvent {
  final String id;
  final int numerical;
  const LoadNextChapter(this.id, this.numerical);
  @override
  List<Object> get props => [id, numerical];
}

class SetStateButtonBackIndex extends ReadChapterEvent {
  final bool visialbe;
  const SetStateButtonBackIndex(this.visialbe);
  @override
  List<Object> get props => [visialbe];
}

class ContinueReading extends ReadChapterEvent {}

class ContinueFailed extends ReadChapterEvent {}
