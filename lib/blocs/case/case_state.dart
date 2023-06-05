part of 'case_bloc.dart';

abstract class CaseState extends Equatable {
  const CaseState();

  @override
  List<Object> get props => [];
}

class CaseInitial extends CaseState {}

class CaseAdded extends CaseState {
  @override
  List<Object> get props => [];
}

class CaseLoaded extends CaseState {
  final List<CaseComic> listCaseComic;

  const CaseLoaded(this.listCaseComic);
  @override
  List<Object> get props => [listCaseComic];
}
