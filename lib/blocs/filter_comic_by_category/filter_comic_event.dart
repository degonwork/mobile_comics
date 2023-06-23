import 'package:equatable/equatable.dart';

abstract class FilterComicEvent extends Equatable {
  const FilterComicEvent();
  @override
  List<Object> get props => [];
}

class FilterComicStart extends FilterComicEvent {
  @override
  List<Object> get props => [];
}

class FilterByIDCategory extends FilterComicEvent {
  final String categoryName;
  const FilterByIDCategory(this.categoryName);
  @override
  List<Object> get props => [categoryName];
}

class FilterComicLoadFailed extends FilterComicEvent {
  @override
  List<Object> get props => [];
}
