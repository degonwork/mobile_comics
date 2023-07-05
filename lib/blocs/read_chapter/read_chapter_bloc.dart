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
    // on<LoadNextChapter>(_onLoadNextChapter);
  }
  // Future<void> _onLoadNextChapter(LoadNextChapter event,Emitter<ReadChapterState> emitter)async{
  //   try {
  //     List<Image> listImageNextChapter  = await _chapterRepo.readChapterNext(comicId: event.id,numerical: event.numerical);
  //     // int numerical = await _chapterRepo.readNumericNextChapter(comicId: event.id,numerical: event.numerical);
  //     // String chapterId = await _chapterRepo.readIDChapter(comicId: event.id, numerical: event.numerical);
  //       emitter(LoadedChapter(listImageNextChapter,event.numerical + 1));
      
  //     // int? numerical = (await _chapterRepo.readNumericNextChapter(comicId: event.id,numerical: event.numerical))!.numerical;
  //     // print('${event.numerical} -------------------------');
  //     // emitter(LoadedChapter(listImageNextChapter,numerical!));
  //   } catch (e) {
  //     emitter(ReadChapterLoadFailed());
  //   }
  // }
  Future<void> _onLoadChapter(
      LoadChapter event, Emitter<ReadChapterState> emit) async {
    emit(LoadingChapter());
    try {
      
      List<Image> listImageContent =
          await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
          print(event.id);
      // int numerical = await _chapterRepo.readChapterNumberic(chapterId: event.id);
      
      if (listImageContent.isEmpty) {
        await _chapterRepo.fetchDetailChapters(id: event.id,isUpdate: true);
        List<Image> listImageContent =
            await _chapterRepo.readChapterContentFromDB(chapterId: event.id);
        // int numerical = await _chapterRepo.readChapterNumberic(chapterId: event.id);
        
        // print('$numerical +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');    
        
        emit(LoadedChapter(listImageContent,true));
      } else {
        emit(LoadedChapter(listImageContent,true));
      }
    } catch (e) {
      emit(ReadChapterLoadFailed());
    }
  }
}
