part of 'router_bloc.dart';

class RouterState extends Equatable {
  const RouterState();
  @override
  List<Object> get props => [];
}

class RouterLoaded extends RouterState {
  final Widget currentScreen;
  final int navigatorValue;
  final String routerScreen;
  const RouterLoaded(
    this.currentScreen,
    this.navigatorValue,
    this.routerScreen,
  );

  @override
  List<Object> get props => [currentScreen, navigatorValue, routerScreen];
}
