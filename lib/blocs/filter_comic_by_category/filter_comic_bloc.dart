import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';

class FilterComicBloc extends Bloc<FilterComicEvent,FilterComicState>{
  final ComicRepo _comicRepo;
  FilterComicBloc({required ComicRepo comicRepo}) : _comicRepo = comicRepo,super(LoadComicByCategoryIDInital()){
    on<FilterByIDCategory>(_filterByIDCategory);
  }
  Future<void> _filterByIDCategory(FilterByIDCategory event,Emitter<FilterComicState> emitter)async{
   List<Comic> listComics = await _comicRepo.readComicByCategoryIDFromDB(id: event.id);
   emitter(LoadedComicByCategoryID(listComics));
  }
}