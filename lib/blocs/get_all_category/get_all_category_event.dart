import 'package:equatable/equatable.dart';

abstract class GetAllCategoryEvent extends Equatable {
  const GetAllCategoryEvent();
  @override
  List<Object> get props => [];
}

class GetAllCategory extends GetAllCategoryEvent {
  const GetAllCategory();
  @override
  List<Object> get props => [];
}

class SetStateCategoryIndex extends GetAllCategoryEvent {
  final int index;
  const SetStateCategoryIndex(this.index);
  @override
  List<Object> get props => [index];
}
