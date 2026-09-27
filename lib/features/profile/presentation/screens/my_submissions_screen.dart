import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/profile/presentation/widgets/submission_card.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';
import 'package:quick_bite/features/recipe/presentation/providers/recipe_providers.dart';

class MySubmissionsScreen extends ConsumerStatefulWidget {
  const MySubmissionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MySubmissionsScreenState();
  }
}

class _MySubmissionsScreenState extends ConsumerState<MySubmissionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //navigate to AddRecipeScreen in edit mode
  void _navigateToEdit(Recipe recipe) {
    context.pushNamed(AppRoutes.addRecipe, extra: recipe);
  }

  @override
  Widget build(BuildContext context) {
    final submissionAsync = ref.watch(userSubmissionsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        // scaffoldLineWidth: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          'My Submissions',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: SafeArea(
        child: submissionAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stackTrace) => const Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.error),
                AppSpacing.vSm,
                Text(
                  'Failed to load submissions',
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
          data: (recipes) {
            final pending = recipes
                .where((recipe) => recipe.status == 'pending')
                .toList();
            final approved = recipes
                .where((recipe) => recipe.status == 'approved')
                .toList();
            final rejected = recipes
                .where((recipe) => recipe.status == 'rejected')
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildSubmissionsList(pending, statusType: 'pending'),
                _buildSubmissionsList(approved, statusType: 'approved'),
                _buildSubmissionsList(rejected, statusType: 'rejected'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubmissionsList(
    List<Recipe> items, {
    required String statusType,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            AppSpacing.vSm,
            Text(
              'No $statusType submissions',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => AppSpacing.vSm,
      itemBuilder: (context, index) {
        final recipe = items[index];
        return SubmissionCard(
          submission: recipe,
          onEditPressed: () => _navigateToEdit(recipe),
        );
      },
    );
  }
}
