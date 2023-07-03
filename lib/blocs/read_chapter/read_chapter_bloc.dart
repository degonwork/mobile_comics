import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/read_chapter/read_chapter_event.dart';
import '../../blocs/read_chapter/read_chapter_state.dart';
import '../../data/models/chapter_model.dart';
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
  Future<void> _onLoadNextChapter(
      LoadNextChapter event, Emitter<ReadChapterState> emitter) async {
    try {
      List<Image> listImageNextChapter = await _chapterRepo.readChapterNext(
          comicId: event.id, numerical: event.numerical);
      int numerical =
          await _chapterRepo.readChapterNumberic(chapterId: event.id);
      // print('${event.numerical} -------------------------');
      emitter(LoadedChapter(
        listImageNextChapter,
        // numerical
      ));
    } catch (e) {
      emitter(ReadChapterLoadFailed());
    }
  }

  Future<void> _onLoadChapter(
      LoadChapter event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    List<Image> listImageContent = [];
    Chapter chapter =
        await _chapterRepo.readChapterByIdFromDB(chapterId: event.id);
    if (chapter.isFull == 0) {
      print("chapter not full ----------------------------");
      await _chapterRepo.fetchDetailChapters(id: event.id, isUpdate: true);
      listImageContent =
          await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
      emit(LoadedChapter(listImageContent));
    } else {
      print("chapter is full--------------------------------");
      listImageContent =
          await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
      emit(LoadedChapter(listImageContent));
      await _chapterRepo
          .fetchDetailChapters(id: event.id, isUpdate: true)
          .whenComplete(
        () async {
          await Future.delayed(const Duration(seconds: 1), () async {
            listImageContent = await _chapterRepo.readChapterContentFromDB(
                chapterId: event.id);
            emit(
              LoadedChapter(listImageContent),
            );
          });
        },
      );

      //     int numerical = await _chapterRepo.readChapterNumberic(chapterId: event.id);

      //     if (listImageContent.isEmpty) {
      //       await _chapterRepo.fetchDetailChapters(id: event.id);
      //       List<Image> listImageContent =
      //           await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
      //       int numerical = await _chapterRepo.readChapterNumberic(chapterId: event.id);

      //       emit(LoadedChapter(listImageContent,numerical));
      //     } else {
      //       emit(LoadedChapter(listImageContent,numerical));
      //     }
      //   } catch (e) {
      //     emit(ReadChapterLoadFailed());
    }
  }
}
