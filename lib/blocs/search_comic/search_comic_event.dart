 import 'package:equatable/equatable.dart';

abstract class SearchComicEvent extends Equatable{
  const SearchComicEvent();
@override
List<Object> get props => [];
}
class SearchByQuery extends SearchComicEvent{
  final String query;
  const SearchByQuery(this.query);
  @override
  List<Object> get props => [query];
}