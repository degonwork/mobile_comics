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

class ContinueReading extends ReadChapterEvent {}
