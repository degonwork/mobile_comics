import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'comic_detail_event.dart';
part 'comic_detail_state.dart';

class ComicDetailBloc extends Bloc<ComicDetailEvent, ComicDetailState> {
  ComicDetailBloc() : super(ComicDetailInitial()) {
    on<ComicDetailEvent>((event, emit) {});
  }
}
