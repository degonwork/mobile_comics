import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/read_chapter/read_chapter_event.dart';
import '../../blocs/read_chapter/read_chapter_state.dart';
import '../../data/models/chapter_model.dart';
import '../../data/repository/chapter_repository.dart';
import '../../data/models/image_model.dart';

class ReadChapterBloc extends Bloc<ReadChapterEvent, ReadChapterState> {
  final ChapterRepo _chapterRepo;

  ReadChapterBloc({
    required ChapterRepo chapterRepo,
  })  : _chapterRepo = chapterRepo,
        super(ReadChapterInital()) {
    on<LoadChapter>(_onLoadChapter);
    on<LoadNextChapter>(_onLoadNextChapter);
    on<SetStateButtonBackIndex>(_onSetStateButtonBackIndex);
    on<ContinueReading>(_onContinueReading);
  }

  Future<void> _onLoadNextChapter(
      LoadNextChapter event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    List<Image> listImageNextChapter = [];
    Chapter? chapter = await _chapterRepo.readNextChapter(
        comicId: event.comicId, chapterIndex: event.chapterIndex);
    if (chapter != null && chapter.chapter_index != null) {
      if (chapter.isFull == 0) {
        try {
          await _chapterRepo.fetchDetailChapters(id: chapter.id);
          listImageNextChapter = await _chapterRepo.readChapterContentFromDB(
              chapterId: chapter.id);
          emit(LoadedChapter(
              listImageNextChapter, true, chapter.chapter_index!, chapter.id));
        } catch (e) {
          emit(LoadErrorChapter());
        }
      } else {
        listImageNextChapter =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(
            listImageNextChapter, true, chapter.chapter_index!, chapter.id));
        await _chapterRepo.fetchDetailChapters(id: chapter.id).whenComplete(
          () async {
              listImageNextChapter = await _chapterRepo
                  .readChapterContentFromDB(chapterId: chapter.id);
              emit(LoadedChapter(listImageNextChapter, true,
                  chapter.chapter_index!, chapter.id));
          },
        );
      }
    } else {
      emit(LoadErrorChapter());
    }
  }

  //
  Future<void> _onLoadChapter(
      LoadChapter event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    List<Image> listImageContent = [];
    Chapter? chapter =
        await _chapterRepo.readChapterByIdFromDB(chapterId: event.chapterId);
    if (chapter != null && chapter.chapter_index != null) {
      if (chapter.isFull == 0) {
        try {
          await _chapterRepo.fetchDetailChapters(id: chapter.id);
          listImageContent = await _chapterRepo.readChapterContentFromDB(
              chapterId: chapter.id);
          emit(LoadedChapter(
              listImageContent, true, chapter.chapter_index!, chapter.id));
        } catch (e) {
          emit(LoadErrorChapter());
        }
      } else {
        listImageContent =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(
            listImageContent, true, chapter.chapter_index!, chapter.id));
        await _chapterRepo.fetchDetailChapters(id: chapter.id).whenComplete(
          () async {
              listImageContent = await _chapterRepo.readChapterContentFromDB(
                  chapterId: chapter.id);
              emit(LoadedChapter(
                  listImageContent, true, chapter.chapter_index!, chapter.id));
          
          },
        );
      }
    } else {
      emit(LoadErrorChapter());
    }
  }

  Future<void> _onContinueReading(
      ContinueReading event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    List<Image> listImageChapterContinue = [];
    Chapter? chapter = await _chapterRepo.readChapterByIdFromDB(
        chapterId: event.caseComic.chapterId);
    if (chapter != null && chapter.chapter_index != null) {
      if (chapter.isFull == 0) {
        try {
          await _chapterRepo.fetchDetailChapters(id: chapter.id);
          listImageChapterContinue = await _chapterRepo
              .readChapterContentFromDB(chapterId: chapter.id);
          emit(LoadedChapter(listImageChapterContinue, true,
              chapter.chapter_index!, chapter.id));
        } catch (e) {
          emit(LoadErrorChapter());
        }
      } else {
        listImageChapterContinue =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(listImageChapterContinue, true,
            chapter.chapter_index!, chapter.id));
        await _chapterRepo
            .fetchDetailChapters(id: chapter.id)
            .whenComplete(() async {
          
            listImageChapterContinue = await _chapterRepo
                .readChapterContentFromDB(chapterId: chapter.id);
            emit(LoadedChapter(listImageChapterContinue, true,
                chapter.chapter_index!, chapter.id));
          
        });
      }
    } else {
      emit(LoadErrorChapter());
    }
  }

  void _onSetStateButtonBackIndex(
    SetStateButtonBackIndex event,
    Emitter<ReadChapterState> emit,
  ) {
    if (state is LoadedChapter) {
      emit(
        LoadedChapter(
          (state as LoadedChapter).listImageContent,
          !event.visialbe,
          (state as LoadedChapter).currentNumeric,
          (state as LoadedChapter).chapterId,
        ),
      );
    }
  }
}
