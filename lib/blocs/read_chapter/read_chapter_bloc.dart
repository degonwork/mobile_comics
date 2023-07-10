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
    on<ContinueReading>(_onCountinueReading);
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
          print("chapter not full ----------------------------");
          await _chapterRepo.fetchDetailChapters(
              id: chapter.id, isUpdate: true);
          listImageNextChapter =
          await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
          emit(LoadedChapter(
              listImageNextChapter, true, chapter.chapter_index!, chapter.id));
        } catch(e) {
            emit(LoadErrorChapter());
        }
      }else {
        print("chapter is full--------------------------------");
        listImageNextChapter =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(
            listImageNextChapter, true, chapter.chapter_index!, chapter.id));
        await _chapterRepo
            .fetchDetailChapters(id: chapter.id, isUpdate: true)
            .whenComplete(
          () async {
            await Future.delayed(const Duration(seconds: 1), () async {
              listImageNextChapter = await _chapterRepo
                  .readChapterContentFromDB(chapterId: chapter.id);
              emit(LoadedChapter(listImageNextChapter, true,
                  chapter.chapter_index!, chapter.id));
            });
          },
        );
      }
    }
    emit(LoadErrorChapter());
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
        print("chapter not full ----------------------------");
        await _chapterRepo.fetchDetailChapters(id: chapter.id, isUpdate: true);
        listImageContent =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(
            listImageContent, true, chapter.chapter_index!, chapter.id));
      } else {
        print("chapter is full--------------------------------");
        listImageContent =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(
            listImageContent, true, chapter.chapter_index!, chapter.id));
        await _chapterRepo
            .fetchDetailChapters(id: chapter.id, isUpdate: true)
            .whenComplete(
          () async {
            await Future.delayed(const Duration(seconds: 1), () async {
              listImageContent = await _chapterRepo.readChapterContentFromDB(
                  chapterId: chapter.id);
              emit(LoadedChapter(
                  listImageContent, true, chapter.chapter_index!, chapter.id));
            });
          },
        );
      }
    }
  }

  Future<void> _onCountinueReading(
      ContinueReading event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    List<Image> listImageChapterContinue = [];
    Chapter? chapter = await _chapterRepo.readChapterByIdFromDB(
        chapterId: event.caseComic.chapterId);
    if (chapter != null && chapter.chapter_index != null) {
      if (chapter.isFull == 0) {
        print("chapter not full ----------------------------");
        await _chapterRepo.fetchDetailChapters(id: chapter.id, isUpdate: true);
        listImageChapterContinue =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(listImageChapterContinue, true,
            chapter.chapter_index!, chapter.id));
      } else {
        print("chapter is full--------------------------------");
        listImageChapterContinue =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
        emit(LoadedChapter(listImageChapterContinue, true,
            chapter.chapter_index!, chapter.id));
        await Future.delayed(const Duration(seconds: 1), () async {
          listImageChapterContinue = await _chapterRepo
              .readChapterContentFromDB(chapterId: chapter.id);
          emit(LoadedChapter(listImageChapterContinue, true,
              chapter.chapter_index!, chapter.id));
        });
      }
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
