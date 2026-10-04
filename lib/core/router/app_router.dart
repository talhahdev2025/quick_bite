import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/core/router/router_notifer.dart';
import 'package:quick_bite/features/add_recipe/presentation/screens/add_recipe_screen.dart';
import 'package:quick_bite/features/admin/presentation/screens/dashboard_screen.dart';
import 'package:quick_bite/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:quick_bite/features/profile/presentation/screens/my_submissions_screen.dart';
import 'package:quick_bite/features/profile/presentation/screens/profile_screen.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';
import 'package:quick_bite/features/home/presentation/screens/home_screen.dart';
import 'package:quick_bite/features/home/presentation/screens/recipe_detail_screen.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/login/presentation/screens/login_screen.dart';
import 'package:quick_bite/core/router/app_shell.dart';
import 'package:quick_bite/features/splash/presentation/providers/provider.dart';
import 'package:quick_bite/features/splash/presentation/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);
  final onboardingAsync = ref.watch(onboardingCompletedProvider);
  // final authState = ref.read(authProvider);
  // final bool isAdmin=authState.user?.role=='admin';
  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: notifier,
    redirect: (context, state) {
      //wait until onboarding statis is loaded
      if (onboardingAsync.isLoading) return null;
      final hasCompletedOnboarding = onboardingAsync.value ?? false;
      // obtain current auth state
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isLoggedIn;
      //current location flags
      final isOnboardingRoute = state.matchedLocation == AppRoutes.splashPath;
      final isLogginRoute = state.matchedLocation == AppRoutes.loginPath;
      //rule A: If user hasn't finished onboarding, force them to Onboarding
      if (!hasCompletedOnboarding) {
        return isOnboardingRoute ? null : AppRoutes.splashPath;
      }
      // Rule B: If onboarding IS completed and user is still on Onboarding
      if (isOnboardingRoute) {
        return isLoggedIn ? AppRoutes.homePath : AppRoutes.loginPath;
      }
      // Rule C: If user is NOT logged in and trying to go anywhere except Login
      if (!isLoggedIn && !isLogginRoute) {
        return AppRoutes.loginPath;
      }
      // Rule D: If user IS logged in and trying to access Login screen
      if (isLoggedIn && isLogginRoute) {
        return AppRoutes.homePath;
      }
      //allow navigation to proceed
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // final authState = ref.read(authProvider);
          return MainNavigation(
            navigationShell: navigationShell,
            // isAdmin: authState.user?.role == 'admin',
          );
        },
        branches: [
          //home screen branch
          StatefulShellBranch(
            routes: [
              //home
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
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
                builder: (context, state) {
                  final recipe = state.extra as Recipe?;
                  return AddRecipeScreen(recipe: recipe);
                },
              ),
            ],
          ),
          //favorite screen branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favoritePath,
                name: AppRoutes.favorite,
                builder: (context, state) => const FavoriteScreen(),
              ),
            ],
          ),

          //profile screen branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),

              //admin dashboard
              GoRoute(
                path: AppRoutes.adminDashboardPath,
                name: AppRoutes.adminDashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
              // my submissions screen
              GoRoute(
                path: AppRoutes.mySubmissionsPath,
                name: AppRoutes.mySubmissions,
                builder: (context, state) => const MySubmissionsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
});
