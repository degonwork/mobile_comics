part of 'case_bloc.dart';

abstract class CaseState extends Equatable {
  const CaseState();

  @override
  List<Object> get props => [];
}

class CaseInitial extends CaseState {}

class CaseLoading extends CaseState {}

class CaseLoaded extends CaseState {
  final List<CaseComic> listCaseComic;

  const CaseLoaded(this.listCaseComic);

  @override
  List<Object> get props => [listCaseComic];
}

class CaseLoadError extends CaseState {}

