part of 'view_more_bloc.dart';

abstract class ViewMoreState extends Equatable {
  const ViewMoreState();

  @override
  List<Object> get props => [];
}

class ViewMoreInitial extends ViewMoreState {}

class ViewMoreLoaded extends ViewMoreState {
  final List<Comic> listNewComicsViewMore;
  const ViewMoreLoaded(this.listNewComicsViewMore);

  @override
  List<Object> get props => [listNewComicsViewMore];
}

class ViewMoreLoadFailed extends ViewMoreState {}
