import 'package:equatable/equatable.dart';
import 'package:full_comics_frontend/data/models/chapter_model.dart';

abstract class ReadChapterState extends Equatable{
  const ReadChapterState();
  @override
  List<Object> get props => [];
}
class LoadChapterInital extends ReadChapterState{}
class LoadedChapter extends ReadChapterState{
  final Chapter chapter;
  const LoadedChapter(this.chapter);
  @override
  List<Object> get props => [chapter];
}