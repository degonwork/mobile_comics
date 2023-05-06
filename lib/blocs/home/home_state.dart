part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.listHotComics,
    required this.listNewComics,
  });
  final List<Comic> listHotComics;
  final List<Comic> listNewComics;

  @override
  List<Object> get props => [listHotComics, listNewComics];
}
