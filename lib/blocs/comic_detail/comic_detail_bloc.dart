import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'comic_detail_event.dart';
part 'comic_detail_state.dart';

class ComicDetailBloc extends Bloc<ComicDetailEvent, ComicDetailState> {
  ComicDetailBloc() : super(ComicDetailInitial()) {
    on<ComicDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
