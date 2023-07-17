part of 'router_bloc.dart';

abstract class RouterEvent extends Equatable {
  const RouterEvent();
  @override
  List<Object> get props => [];
}

class ResetBottomNavBar extends RouterEvent {
  final Widget currentScreen;
  final int navigatiorValue;

  const ResetBottomNavBar(this.currentScreen, this.navigatiorValue);

  @override
  List<Object> get props => [currentScreen];
}

class ChangeBottomNavBar extends RouterEvent {
  final Widget currentScreen;
  final int navigatiorValue;

  const ChangeBottomNavBar(this.currentScreen, this.navigatiorValue);

  @override
  List<Object> get props => [currentScreen];
}

class SetRouterScreen extends RouterEvent {
  final String routerScreen;
  const SetRouterScreen(this.routerScreen);
  @override
  List<Object> get props => [routerScreen];
}
