part of 'ads_bloc.dart';

abstract class AdsState extends Equatable {
  const AdsState();
  @override
  List<Object> get props => [];
}

class AdsInitial extends AdsState {}

// ignore: must_be_immutable
class AdsShow extends AdsState {
  int adsTimes;
  final bool hasError;
  AdsShow(this.adsTimes, {required this.hasError});
  @override
  List<Object> get props => [adsTimes, hasError];
}
