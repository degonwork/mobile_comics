part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState({required this.listHotComic, required this.listNewComic});
  final List<HomeComic> listHotComic;
  final List<HomeComic> listNewComic;

  @override
  List<Object> get props => [];
}

// class HomeInitial extends HomeState {}
