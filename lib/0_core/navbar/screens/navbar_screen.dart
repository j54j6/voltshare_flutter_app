import 'package:flutter/material.dart';
import '../widgets/navbar_widget.dart';

class NavbarScreen extends StatelessWidget {
  final Widget child;

  const NavbarScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Voltshare")),
      ),
      body: child, // Router liefert hier den aktuellen Screen
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
