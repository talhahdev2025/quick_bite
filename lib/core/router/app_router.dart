import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/core/router/router_notifer.dart';
import 'package:quick_bite/features/add_recipe/presentation/screens/add_recipe_screen.dart';
import 'package:quick_bite/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';
import 'package:quick_bite/features/home/presentation/screens/home_screen.dart';
import 'package:quick_bite/features/home/presentation/screens/recipe_detail_screen.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/login/presentation/screens/login_screen.dart';
import 'package:quick_bite/core/router/app_shell.dart';
import 'package:quick_bite/features/splash/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isLoggedIn;

      final isSplash = state.matchedLocation == AppRoutes.splashPath;
      final isLogginIn = state.matchedLocation == AppRoutes.loginPath;

      if (isSplash) return null;
      if (!isLoggedIn && !isLogginIn) return AppRoutes.loginPath;
      if (isLoggedIn && isLogginIn) return AppRoutes.homePath;

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigation(navigationShell: navigationShell),
        branches: [
          //home screen branch
          StatefulShellBranch(
            routes: [
              //home
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.home,
                builder: (context, state) => HomeScreen(),
              ),
              //recipe detail screen
              GoRoute(
                path: AppRoutes.recipeDetailPath,
                name: AppRoutes.recipeDetail,
                builder: (context, state) {
                  final data = state.extra as Recipe;
                  return RecipeDetailScreen(data: data);
                },
              ),
            ],
          ),
          //add recipe branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.addRecipePath,
                name: AppRoutes.addRecipe,
                builder: (context, state) => AddRecipeScreen(),
              ),
            ],
          ),
          //favorite screen branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favoritePath,
                name: AppRoutes.favorite,
                builder: (context, state) => FavoriteScreen(),
              ),
            ],
          ),
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
});
