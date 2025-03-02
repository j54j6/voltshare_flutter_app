import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voltshare/0_core/navbar/screens/navbar_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voltshare/4_application/map/bloc/map_bloc.dart';
import '0_core/navbar/bloc/navbar_bloc.dart';
import '4_application/auth/bloc/auth_bloc.dart';
import '0_core/supabase/bloc/supabase_bloc.dart';
import '0_core/navbar/bloc/navbar_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().initialize();
  final Supabase supabaseClient = SupabaseService().client;

  // Initialisiere den GoRouter
  final router = GoRouter(
    initialLocation: MenuModel().initPath, // Startseite
    routes: [
      ShellRoute(
        builder: (context, state, child) => NavbarScreen(child: child),
        routes: MenuModel().getRoutes(),
      ),
    ],
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavbarBloc>(
          create: (BuildContext context) => NavbarBloc(router: router),
        ), // Router wird übergeben
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(supabase: supabaseClient),
        ),
        BlocProvider<MapBloc>(create: (context) => MapBloc()),
      ],
      child: VoltshareMain(router: router), // Router an die App weitergeben
    ),
  );
}

class VoltshareMain extends StatelessWidget {
  final GoRouter router;

  const VoltshareMain({required this.router, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'Voltshare', routerConfig: router);
  }
}
