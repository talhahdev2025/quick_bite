import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({
    super.key,
    required this.navigationShell,
    required this.isAdmin,
  });
  final StatefulNavigationShell navigationShell;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      //navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (value) => navigationShell.goBranch(value),
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.add_circle_rounded),
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Add Recipe',
          ),
          //favortie
          const NavigationDestination(
            selectedIcon: Icon(Icons.favorite_rounded),
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite',
          ),
          if (isAdmin)
            const NavigationDestination(
              selectedIcon: Icon(Icons.admin_panel_settings),
              icon: Icon(Icons.admin_panel_settings_outlined),
              label: 'Dashboard',
            ),
        ],
      ),
    );
  }
}
