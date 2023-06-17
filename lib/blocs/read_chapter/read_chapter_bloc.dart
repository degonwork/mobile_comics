import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/read_chapter/read_chapter_event.dart';
import '../../blocs/read_chapter/read_chapter_state.dart';
import '../../data/repository/chapter_repository.dart';
import '../../data/models/image_model.dart';

class ReadChapterBloc extends Bloc<ReadChapterEvent, ReadChapterState> {
  final ChapterRepo _chapterRepo;
  ReadChapterBloc({required ChapterRepo chapterRepo})
      : _chapterRepo = chapterRepo,
        super(ReadChapterInital()) {
    on<LoadChapter>(_onLoadChapter);
  }
  Future<void> _onLoadChapter(
      LoadChapter event, Emitter<ReadChapterState> emit) async {
    try {
      List<Image> listImageContent =
          await _chapterRepo.fetchDetailChapters(id: event.id);
      emit(LoadedChapter(listImageContent));
    } catch (e) {
      emit(ReadChapterLoadFailed());
    }
  }
}
