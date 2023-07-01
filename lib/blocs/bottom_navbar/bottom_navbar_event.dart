part of 'bottom_navbar_bloc.dart';

abstract class BottomNavbarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeBottomNavbarEvent extends BottomNavbarEvent {
  final Widget currentScreen;
  final int navigatiorValue;

  ChangeBottomNavbarEvent(
    this.currentScreen,
    this.navigatiorValue,
  );

  @override
  List<Object> get props => [currentScreen];
}
