import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constant.dart';
import '../../data/repository/ads_repository.dart';
part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(AdsInitial()) {
    on<LoadAds>(_onLoadAds);
    on<Increment>(_increment);
    on<Reset>(_reset);
  }

  Future<void> _onLoadAds(LoadAds event, Emitter<AdsState> emit) async {
    try {
      await MobileAds.instance.initialize();
      ADSRepo.loadADS();
      emit(AdsShow(0, hasError: false));
    } catch (e) {
      emit(AdsShow(0, hasError: true));
    }
  }

  Future<void> _increment(Increment event, Emitter<AdsState> emitter) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    int adsTimesIn = 1;
    final adsTimes = sharedPreferences.getInt(AppConstant.timeAdsLocal);
    if (adsTimes != null && adsTimes > 0) {
      adsTimesIn = adsTimes;
    }
    if (state is AdsShow) {
      (state as AdsShow).adsTimes += 1;
      if ((state as AdsShow).adsTimes >= adsTimesIn &&
          (state as AdsShow).hasError != true) {
        ADSRepo.showADS();
        add(Reset());
      }
    }
  }

  void _reset(Reset event, Emitter<AdsState> emitter) {
    if (state is AdsShow) {
      (state as AdsShow).adsTimes = 0;
    }
  }
}
