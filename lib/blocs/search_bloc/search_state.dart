import 'package:equatable/equatable.dart';

import '../../data/models/comic_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Comic> comics;
  const SearchLoaded({required this.comics});
  @override
  List<Object?> get props => [comics];
}

class SearchFailure extends SearchState {}
