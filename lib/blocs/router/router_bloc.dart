import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/screens/router/router_screen.dart';
import '../../ui/screens/home/home_screen.dart';
part 'router_event.dart';
part 'router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  RouterBloc()
      : super(const RouterLoaded(HomeScreen(), 0, RouterScreen.routeName)) {
    on<ChangeBottomNavBar>(_onChangeRouterState);
    on<SetRouterScreen>(_onSetRouterScreen);
    on<ResetBottomNavBar>(_onResetBottomNavBar);
  }
  void _onChangeRouterState(
      ChangeBottomNavBar event, Emitter<RouterState> emit) {
    if (state is RouterLoaded) {
      emit(RouterLoaded(event.currentScreen, event.navigatiorValue,
          (state as RouterLoaded).routerScreen));
    }
  }

  void _onSetRouterScreen(
    SetRouterScreen event,
    Emitter<RouterState> emit,
  ) {
    if (state is RouterLoaded) {
      emit(
        RouterLoaded(
          (state as RouterLoaded).currentScreen,
          (state as RouterLoaded).navigatorValue,
          event.routerScreen,
        ),
      );
    }
  }

  void _onResetBottomNavBar(
    ResetBottomNavBar event,
    Emitter<RouterState> emit,
  ) {
    emit(RouterLoaded(
        event.currentScreen, event.navigatiorValue, RouterScreen.routeName));
  }
}
