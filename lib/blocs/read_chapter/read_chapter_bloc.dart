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
    on<LoadNextChapter>(_onLoadNextChapter);
  }
  Future<void> _onLoadNextChapter(LoadNextChapter event,Emitter<ReadChapterState> emitter)async{
    
    try {
      List<Image> listImageNextChapter  = await _chapterRepo.readChapterNext(comicId: event.comicId, numerical: event.numerical);
      emitter(LoadedChapter(listImageNextChapter));
    } catch (e) {
      emitter(ReadChapterLoadFailed());
    }
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
