import 'package:equatable/equatable.dart';
import '../../data/models/image_model.dart';

abstract class ReadChapterState extends Equatable {
  const ReadChapterState();
  @override
  List<Object> get props => [];
}

class ReadChapterInital extends ReadChapterState {}

class LoadingChapter extends ReadChapterState {}

class LoadedChapter extends ReadChapterState {
  final bool visialbe;
  final List<Image> listImageContent;
  // final int currentNumeric;
  const LoadedChapter(this.listImageContent, this.visialbe
      // ,this.currentNumeric
      );
  @override
  List<Object> get props => [
        listImageContent,
        visialbe
        // currentNumeric
      ];
}

class ReadChapterLoadFailed extends ReadChapterState {}
