import 'package:equatable/equatable.dart';

abstract class GetAllCategoryState extends Equatable {
  const GetAllCategoryState();
  @override
  List<Object?> get props => [];
}

class GetInitial extends GetAllCategoryState {}

class GetLoadded extends GetAllCategoryState {
  final List<String> listCategories;
  final int index;
  const GetLoadded(this.listCategories, this.index);
  @override
  List<Object?> get props => [listCategories, index];
}
