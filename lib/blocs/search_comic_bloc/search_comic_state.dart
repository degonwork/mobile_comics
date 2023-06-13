import 'package:equatable/equatable.dart';

import '../../data/models/comic_model.dart';

abstract class SearchComicState extends Equatable{
  const SearchComicState();
  @override
  List<Object> get props => [];
}
class SearchInitial extends SearchComicState{}
class SearchLoading extends SearchComicState{}
class SearchLoadded extends SearchComicState{
  final List<Comic> listComics;
  const SearchLoadded(this.listComics);
  @override
  List<Object> get props => [listComics];
}
class SearchError extends SearchComicState{}