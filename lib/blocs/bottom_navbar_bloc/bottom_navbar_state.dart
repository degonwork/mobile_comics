part of 'bottom_navbar_bloc.dart';

class BottomNavbarState extends Equatable {
  final Widget currentScreen;
  final int navigatorValue;
  const BottomNavbarState({
    this.currentScreen = const HomeScreen(),
    this.navigatorValue = 0,
  });
  @override
  List<Object> get props => [currentScreen, navigatorValue];
}

class ChangeBottomNavbarError extends BottomNavbarState {
  @override
  List<Object> get props => [];
}
