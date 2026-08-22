import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/favorite/screens/favorite_screen.dart';
import 'package:quick_bite/features/home/screens/home_screen.dart';
import 'package:quick_bite/features/login/presentation/screens/login_screen.dart';
import 'package:quick_bite/core/router/app_shell.dart';
import 'package:quick_bite/features/splash/screens/splash_screen.dart';

class AppRouter {
  static GoRouter routes = GoRouter(
    initialLocation: AppRoutes.splashPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigation(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.home,
                builder: (context, state) => HomeScreen(),
              ),
              
            ],
          ),
          //favorite screen branch
          StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.favoritePath,
                name: AppRoutes.favorite,
                builder: (context, state) => FavoriteScreen(),
              ),
          ])
        ],
      ),
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => LoginScreen(),
      ),
    ],
  );
}
