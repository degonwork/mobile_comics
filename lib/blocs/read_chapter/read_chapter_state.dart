import 'package:equatable/equatable.dart';
import '../../data/models/image_model.dart';

abstract class ReadChapterState extends Equatable {
  const ReadChapterState();
  @override
  List<Object> get props => [];
}

class ReadChapterInital extends ReadChapterState {}

class LoadedChapter extends ReadChapterState {
  final List<Image> listImageContent;

  const LoadedChapter(this.listImageContent);
  @override
  List<Object> get props => [listImageContent];
}

class ReadChapterLoadFailed extends ReadChapterState {}
