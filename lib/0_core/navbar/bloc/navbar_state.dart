/*
class NavbarState {
  final int selectedIndex;

  NavbarState(
      {this.selectedIndex = 0}); // Standardmäßig ist der erste Tab aktiv
}
*/

import 'package:voltshare/0_core/navbar/bloc/navbar_menu.dart';

abstract class NavbarState {
  final List<MenuItem> items;
  final int selectedIndex;

  NavbarState({
    required this.items,
    required this.selectedIndex,
  });

  List<Object?> get props => [items, selectedIndex];
}

class NavbarInitialState extends NavbarState {
  NavbarInitialState()
      : super(
          items: MenuModel().pages,
          selectedIndex: 0,
        );
}

class NavbarLoadedState extends NavbarState {
  NavbarLoadedState({
    required super.selectedIndex,
  }) : super(
          items: MenuModel().pages,
        );
}

class NavbarErrorState extends NavbarState {
  final String errorMessage;

  NavbarErrorState({
    required this.errorMessage,
    required super.selectedIndex,
  }) : super(
          items: MenuModel().pages,
        );

  @override
  List<Object?> get props => super.props..add(errorMessage);
}
