import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navbar_bloc.dart';
import '../bloc/navbar_state.dart';
import '../bloc/navbar_events.dart';
import '../bloc/navbar_menu.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        // Hole den aktuellen Index aus dem NavbarState
        final currentIndex = state.selectedIndex;

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            context.read<NavbarBloc>().add(NavbarItemTappedEvent(index));
          },
          items: MenuModel().getBottomNavigationBarItems(),
        );
      },
    );
  }
}
