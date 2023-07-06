import 'dart:async';

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
    on<SetStateButtonBackIndex>(_onSetStateButtonBackIndex);
    on<ContinueReading>(_onCountinueLoading);
  }
  Future<void> _onLoadNextChapter(LoadNextChapter event,Emitter<ReadChapterState> emitter)async{
    try {
      Chapter? chapter = await _chapterRepo.readNextChapter(comicId: event.id, chapterIndex: event.chapterIndex);
      if (chapter != null && chapter.chapter_index != null) {
        List<Image> listImageNextChapter  = await _chapterRepo.readImageFromNextChapter(comicId: event.id,chapterIndex: event.chapterIndex);
        print(listImageNextChapter.toString() + 'dfsddddddddddddddddddddddddddddddddddddddddddddddddd');
        if (listImageNextChapter.isEmpty) {
        await _chapterRepo.fetchDetailChapters(id: chapter.id,isUpdate: true);
        List<Image> listImageContentNextChapter =
            await _chapterRepo.readChapterContentFromDB(chapterId: chapter.id);
print(listImageContentNextChapter.toString() + 'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
            emitter(LoadedChapter(listImageContentNextChapter,true,chapter.chapter_index!));
      }else{
        emitter(LoadedChapter(listImageNextChapter,true,chapter.chapter_index!));
      }
      }
      // List<Image> listImageNextChapter  = await _chapterRepo.readImageFromNextChapter(comicId: event.id,chapterIndex: event.chapterIndex);
      // print(listImageNextChapter);
      
//       if (listImageNextChapter.isEmpty) {
//         await _chapterRepo.fetchDetailChapters(id: event.id,isUpdate: true);
//         List<Image> listImageContentNextChapter =
//             await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
// print(listImageContentNextChapter.toString() + 'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
//             emitter(LoadedChapter(listImageContentNextChapter,true));
//       }else{
//         emitter(LoadedChapter(listImageNextChapter,true));
//       }
    } catch (e) {
      emitter(ReadChapterLoadFailed());
    }
  }
  //
  Future<void> _onLoadChapter(
      LoadChapter event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    List<Image> listImageContent = [];
    Chapter chapter =
        await _chapterRepo.readChapterByIdFromDB(chapterId: event.id);
        int chapterIndex = await _chapterRepo.readChapterIndex(chapterId: event.id);
    if (chapter.isFull == 0) {
      print("chapter not full ----------------------------");
      await _chapterRepo.fetchDetailChapters(id: event.id, isUpdate: true);
      listImageContent =
          await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
      emit(LoadedChapter(listImageContent, true,chapterIndex));
    } else {
      print("chapter is full--------------------------------");
      listImageContent =
          await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
      emit(LoadedChapter(listImageContent, true,chapterIndex));
      await _chapterRepo
          .fetchDetailChapters(id: event.id, isUpdate: true)
          .whenComplete(
        () async {
          await Future.delayed(const Duration(seconds: 1), () async {
            listImageContent = await _chapterRepo.readChapterContentFromDB(
                chapterId: event.id);
            emit(
              LoadedChapter(listImageContent, true,chapterIndex),
            );
          });
        },
      );
    }
  }
 
  void _onSetStateButtonBackIndex(
    SetStateButtonBackIndex event,
    Emitter<ReadChapterState> emit,
  ) {
    if (state is LoadedChapter) {
      emit(LoadedChapter(
          (state as LoadedChapter).listImageContent, !event.visialbe,(state as LoadedChapter).currentNumeric));
    }
  }

  Future<void> _onCountinueLoading(ContinueReading event, Emitter<ReadChapterState> emit) async{
    
  }
}
