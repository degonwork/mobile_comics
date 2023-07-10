import 'package:equatable/equatable.dart';

abstract class GetAllCategoryState extends Equatable {
  const GetAllCategoryState();
  @override
  List<Object?> get props => [];
}

class GetAllCategoryInitial extends GetAllCategoryState {}

class GetAllCategoryLoading extends GetAllCategoryState {}


class GetAllCategoryLoaded extends GetAllCategoryState {
  final List<String> listCategories;
  final int index;
  const GetAllCategoryLoaded(this.listCategories, this.index);
  @override
  List<Object?> get props => [listCategories, index];
}

class GetAllCategoryLoadError extends GetAllCategoryState {}


