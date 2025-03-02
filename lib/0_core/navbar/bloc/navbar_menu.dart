import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../4_application/map/screens/map_screen.dart';
import '../../../0_core/supabase/bloc/supabase_bloc.dart';
import '../../../4_application/auth/bloc/auth_bloc.dart';
import '../../../4_application/auth/bloc/auth_state.dart';
import '../../../4_application/auth/screens/auth_login_screen.dart';

class MenuItem {
  final Widget page;
  final bool needAuth;
  final String location;
  final String label;
  final bool inNavbar;
  final Widget icon;

  MenuItem({
    required this.page,
    required this.needAuth,
    required this.location,
    required this.label,
    required this.inNavbar,
    required this.icon,
  });
}

class MenuModel {
  Supabase supabase = SupabaseService().client;
  MenuModel._internal();
  static final MenuModel _instance = MenuModel._internal();
  factory MenuModel() => _instance;
  final String initPath = '/charge_map';

  List<MenuItem> pages = [
    MenuItem(
      page: MapScreen(),
      needAuth: true,
      icon: Icon(Icons.flash_on),
      label: 'Home',
      inNavbar: false,
      location: '/',
    ),
    MenuItem(
      page: MapScreen(),
      needAuth: true,
      icon: Icon(Icons.flash_on),
      label: 'Charge',
      inNavbar: true,
      location: '/charge_map',
    ),
    MenuItem(
      page: Scaffold(body: Center(child: Text('Your Wallboxes'))),
      needAuth: true,
      icon: Icon(Icons.ev_station),
      label: 'My Wallboxes',
      inNavbar: true,
      location: '/wallboxes',
    ),
    MenuItem(
      page: Scaffold(body: Center(child: Text('My Sessions'))),
      needAuth: true,
      icon: Icon(Icons.history),
      label: 'History',
      inNavbar: true,
      location: '/history',
    ),
    MenuItem(
      page: Scaffold(body: Center(child: Text('Profile Screen'))),
      needAuth: true,
      icon: Icon(Icons.person),
      label: 'Profile',
      inNavbar: false,
      location: '/profile',
    ),
    MenuItem(
      page: Scaffold(body: Center(child: Text('Settings'))),
      needAuth: false,
      icon: Icon(Icons.settings),
      label: 'Settings',
      inNavbar: true,
      location: '/settings',
    ),
    MenuItem(
      page: LoginScreen(targetRoute: '/charge_map'),
      needAuth: false,
      icon: Icon(Icons.lock),
      label: 'Login',
      inNavbar: false,
      location: '/login',
    ),
  ];

  MenuItem getPage(int index) {
    if (index < 0 || index >= pages.length) {
      throw RangeError('Index $index out of bounds for pages.');
    }
    return pages[index];
  }

  List getPagesAsList() {
    return pages.map((e) => e.page).toList();
  }

  List<Page> getPagesAsPageList() {
    return pages.map((e) => MaterialPage(child: e.page)).toList();
  }

  List<RouteBase> getRoutes() {
    return pages.map((page) {
      return GoRoute(
        path: page.location,
        builder: (context, state) => page.page,
        redirect:
            page.needAuth
                ? (context, state) => _authGuard(context, page.location)
                : null, // Kein Redirect, wenn keine Authentifizierung erforderlich ist
      );
    }).toList();
  }

  List<BottomNavigationBarItem> getBottomNavigationBarItems() {
    return pages
        .where((page) => page.inNavbar)
        .map(
          (page) => BottomNavigationBarItem(icon: page.icon, label: page.label),
        )
        .toList();
  }

  String? _authGuard(BuildContext context, String redirectPath) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return null; // Kein Redirect
    }
    return '/login?redirect=$redirectPath'; // Redirect to Login
  }

  String indexToPath(int index) {
    final navbarPages =
        MenuModel().pages.where((page) => page.inNavbar).toList();

    if (index >= 0 && index < navbarPages.length) {
      return navbarPages[index].location;
    }

    // Fallback: Erste Seite in der Navbar oder allgemeine Fallback-Seite
    return navbarPages.isNotEmpty
        ? navbarPages.first.location
        : MenuModel().pages[0].location;
  }

  // Mappe Pfade auf Index
  int pathToIndex(String path) {
    final pages = MenuModel().pages;
    for (int i = 0; i < pages.length; i++) {
      if (pages[i].location == path && pages[i].inNavbar) {
        return i;
      }
    }
    // Fallback, wenn der Pfad nicht gefunden wird
    return 0;
  }
}
