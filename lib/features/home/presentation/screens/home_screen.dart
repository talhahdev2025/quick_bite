import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/home/presentation/provider/providers.dart';
import 'package:quick_bite/features/home/presentation/widgets/home_card.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = ref.watch(filteredRecipesProvider);
    final authState = ref.watch(authProvider);
    final userName = authState.user?.displayName;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(recipeProvider);
              await ref.read(recipeProvider.future);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Top Header & Search Section
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.surface,
                    padding: AppInsets.screen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${userName ?? "Foodie"}! 👋',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                AppSpacing.vXs,
                                const Text(
                                  'Delicious Recipes\nfor you',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : _handleSignOut,
                              tooltip: 'Sign Out',
                              icon: authState.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.logout_rounded,
                                      color: AppColors.textSecondary,
                                    ),
                            ),
                          ],
                        ),
                        AppSpacing.vLg,
                        // Search Text Field
                        TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            ref
                                .read(searchQueryProvider.notifier)
                                .setQuery(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search by recipe, cuisine, or tags...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textHint,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      _searchController.clear();
                                      ref
                                          .read(searchQueryProvider.notifier)
                                          .clear();
                                      // setState(() {});
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: AppColors.background,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: AppRadius.xLarge,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Recipes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        filteredRecipes.maybeWhen(
                          data: (list) => Text(
                            '${list.length} found',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recipe Content
                filteredRecipes.when(
                  loading: () => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (error, stackTrace) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: AppInsets.screen,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 64,
                              color: AppColors.textHint,
                            ),
                            AppSpacing.vMd,
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium,
                            ),
                            AppSpacing.vLg,
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.large,
                                ),
                              ),
                              onPressed: () {
                                ref.invalidate(recipeProvider);
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  data: (recipes) {
                    if (recipes.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: AppColors.textHint,
                              ),
                              AppSpacing.vMd,
                              const Text(
                                'No recipes found matching your search',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              AppSpacing.vMd,
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(searchQueryProvider.notifier)
                                      .clear();
                                  // setState(() {});
                                },
                                child: const Text('Clear search'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          final isWideScreen =
                              constraints.crossAxisExtent > 600;

                          if (isWideScreen) {
                            return SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 400,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.82,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    HomeCard(data: recipes[index]),
                                childCount: recipes.length,
                              ),
                            );
                          }

                          return SliverList.separated(
                            itemCount: recipes.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return HomeCard(data: recipes[index]);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
