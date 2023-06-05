import 'package:equatable/equatable.dart';

abstract class FilterComicEvent extends Equatable{
  const FilterComicEvent();
  @override
  List<Object> get props => [];
}
class FilterByIDCategory extends FilterComicEvent{
  final String id;
  const FilterByIDCategory(this.id);
  @override
  List<Object> get props => [id];
}