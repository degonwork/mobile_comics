
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/repository/ads_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  
  AdsBloc() : super(ADsShow(0)) {
    on<Increment>(_increment);
    on<Reset>(_reset);
  }
  Future<void> _increment(Increment event,Emitter<AdsState> emitter)async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int adsTimesIn = 1;
    final adsTimes = sharedPreferences.getInt(AppConstant.timeAdsLocal);
      if (adsTimes != null && adsTimes > 0) {
        adsTimesIn = adsTimes;
      }
      if (state is ADsShow) {
        // print('${(state as ADsShow).adsTimes} bnxjhnxhzxhxxdhsdhdsd');
        if ((state as ADsShow).adsTimes >= adsTimesIn) {
          ADSRepo.showADS();
          add(Reset());
        }else{
          (state as ADsShow).adsTimes += 1;
        }
      }
  
  }
   void _reset(Reset event, Emitter<AdsState> emitter){
    if (state is ADsShow) {
      (state as ADsShow).adsTimes = 0;
    }
  }
}
