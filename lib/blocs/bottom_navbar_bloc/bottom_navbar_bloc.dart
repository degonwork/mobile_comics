import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/screens/home/home_screen.dart';
part 'bottom_navbar_event.dart';
part 'bottom_navbar_state.dart';

class BottomNavbarBloc extends Bloc<BottomNavbarEvent, BottomNavbarState> {
  BottomNavbarBloc() : super(const BottomNavbarState()) {
    on<ChangeBottomNavbarEvent>(_onChangeBottomNavbarState);
  }
  void _onChangeBottomNavbarState(
      ChangeBottomNavbarEvent event, Emitter<BottomNavbarState> emit) {
    try {
      emit(BottomNavbarState(currentScreen: event.currentScreen));
    } catch (e) {
      emit(ChangeBottomNavbarError());
    }
  }
}
