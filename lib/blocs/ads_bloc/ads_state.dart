part of 'ads_bloc.dart';

abstract class AdsState   {
  const AdsState();
}

class AdsInitial extends AdsState {}
class ADsShow extends AdsState{
  int adsTimes;
  ADsShow(this.adsTimes);
}
