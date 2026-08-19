import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/screens/home/home_screen.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (value) => navigationShell.goBranch(value),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_outlined),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          //favortie
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_outline_rounded),
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
