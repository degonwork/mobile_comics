import 'package:equatable/equatable.dart';

abstract class GetAllCategoryState extends Equatable {
  const GetAllCategoryState();
  @override
  List<Object?> get props => [];
}

class GetInitial extends GetAllCategoryState {}

class GetLoadded extends GetAllCategoryState {
  final List<String> listCategories;
  const GetLoadded(this.listCategories);
  @override
  List<Object?> get props => [listCategories];
}

class GetFailure extends GetAllCategoryState {}
