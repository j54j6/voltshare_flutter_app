import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'navbar_events.dart';
import 'navbar_state.dart';
import '../../../0_core/navbar/bloc/navbar_menu.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final GoRouter router;

  NavbarBloc({required this.router})
      : super(NavbarLoadedState(selectedIndex: 0)) {
    on<NavbarItemTappedEvent>(_onNavbarItemTapped);
    // on<UpdateNavbarAuthStateEvent>(_onUpdateAuthState);
  }

  Future<void> _onNavbarItemTapped(
      NavbarItemTappedEvent event, Emitter<NavbarState> emit) async {
//    emit(Navbar());
//    await Future.delayed(const Duration(milliseconds: 200));

    emit(NavbarLoadedState(selectedIndex: event.index));
    router.go(MenuModel().indexToPath(event.index));
  }

/*
  Future<void> _onUpdateAuthState(
      UpdateNavbarAuthStateEvent event, Emitter<NavbarState> emit) async {
    if (event.isAuthenticated) {
      emit(NavbarAuthState(true));
    } else {
      emit(NavbarAuthState(false));
    }
  }
  */
}
