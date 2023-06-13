import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_event.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_state.dart';
import 'package:full_comics_frontend/data/models/comic_model.dart';
import 'package:full_comics_frontend/data/repository/category_repository.dart';
import 'package:full_comics_frontend/data/repository/comic_repository.dart';

class FilterComicBloc extends Bloc<FilterComicEvent,FilterComicState>{
  final ComicRepo _comicRepo;
  final CategoryRepo _categoryRepo;
  FilterComicBloc({required ComicRepo comicRepo,required CategoryRepo categoryRepo}) : _comicRepo = comicRepo,_categoryRepo = categoryRepo,super(LoadComicByCategoryIDInital()){
    on<FilterByIDCategory>(_filterByIDCategory);
    on<FilterComicInitial>(_filterComicInitial);
    
  }
 
  Future<void> _filterComicInitial(FilterComicInitial event, Emitter<FilterComicState> emitter)async{
    final listCategories = await _categoryRepo.getAllCategory();
   final comicIndexFirst = await _comicRepo.readComicByCategoryIDFromDB(id: listCategories[0].id);
    emitter(LoadedComicByCategoryID(comicIndexFirst));
  }
  Future<void> _filterByIDCategory(FilterByIDCategory event,Emitter<FilterComicState> emitter)async{
   List<Comic> listComics = await _comicRepo.readComicByCategoryIDFromDB(id: event.id);
   emitter(LoadedComicByCategoryID(listComics));
  }
}