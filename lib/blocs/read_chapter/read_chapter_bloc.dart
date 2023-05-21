import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_event.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_state.dart';
import 'package:full_comics_frontend/data/repository/chapter_repository.dart';

import '../../data/models/image_model.dart';

class ReadChapterBloc extends Bloc<ReadChapterEvent, ReadChapterState> {
  final ChapterRepo _chapterRepo;
  ReadChapterBloc({required ChapterRepo chapterRepo})
      : _chapterRepo = chapterRepo,
        super(LoadChapterInital()) {
    on<LoadChapter>(_onLoadChapter);
  }
  Future<void> _onLoadChapter(
      LoadChapter event, Emitter<ReadChapterState> emit) async {
    List<Image> listImageContent =
        await _chapterRepo.fetchDetailChapters(id: event.id);
    emit(LoadedChapter(listImageContent));
  }
}
