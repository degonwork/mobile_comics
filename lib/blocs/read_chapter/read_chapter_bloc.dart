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
    emit(LoadingChapter());
    try {
      List<Image> listImageContent =
          await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
      if (listImageContent.isEmpty) {
        await _chapterRepo.fetchDetailChapters(id: event.id);
        List<Image> listImageContent =
            await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
        emit(LoadedChapter(listImageContent));
      } else {
        emit(LoadedChapter(listImageContent));
        // await _chapterRepo.fetchDetailChapters(id: event.id).whenComplete(
        //   () async {
        //     List<Image> listImageContent = await _chapterRepo
        //         .readChapterContentFromDB(chapterId: event.id);
        //     emit(LoadedChapter(listImageContent));
        //   },
        // );
      }
    } catch (e) {
      emit(ReadChapterLoadFailed());
    }
  }
}
