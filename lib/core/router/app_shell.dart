import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/features/home/screens/home_screen.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      //navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (value) => navigationShell.goBranch(value),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          //favortie
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_rounded),
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
