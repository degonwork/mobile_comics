part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Comic> lisHotComics;
  final List<Comic> lisNewComics;

  const HomeLoaded(this.lisHotComics, this.lisNewComics);
  @override
  List<Object> get props => [lisHotComics, lisNewComics];
}

class HomeFailed extends HomeState {}
