import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/profile/presentation/widgets/profile_tile.dart';
import 'package:quick_bite/features/profile/presentation/widgets/user_profile_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final isAdmin = authState.user?.role == 'admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: AppSizes.xxl,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // User Header Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: UserProfileHeader(
                name: currentUser?.name ?? 'Student User',
                email: currentUser?.email ?? 'student@example.com',
                isAdmin: isAdmin,
              ),
            ),
          ),

          // Admin Section (Rendered conditionally)
          if (isAdmin) ...[
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Admin Controls'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: ProfileTile(
                  icon: Icons.admin_panel_settings_rounded,
                  iconColor: AppColors.primary,
                  title: 'Pending Approvals',
                  subtitle: 'Review student recipe submissions',
                  // badgeCount: 10,
                  onTap: () {
                    HapticFeedback.vibrate();
                    context.pushNamed(AppRoutes.adminDashboard);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),
          ],

          // Activity Section (Student & General)
          const SliverToBoxAdapter(child: SectionHeader(title: 'My Activity')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            sliver: SliverList.separated(
              itemCount: 2,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ProfileTile(
                    icon: Icons.assignment_outlined,
                    iconColor: AppColors.primary,
                    title: 'My Submissions',
                    subtitle: 'Track pending, approved, and rejected recipes',
                    onTap: () {
                      HapticFeedback.vibrate();
                      context.pushNamed(AppRoutes.mySubmissions);
                    },
                  );
                }
                // return ProfileTile(
                //   icon: Icons.favorite_border_rounded,
                //   iconColor: AppColors.primary,
                //   title: 'Saved Favorites',
                //   subtitle: 'Quick access to your bookmarked recipes',
                //   onTap: () {
                //     HapticFeedback.vibrate();
                //     context.pushNamed(AppRoutes.favorite);
                //   },
                // );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),

          // Account Settings Section
          const SliverToBoxAdapter(child: SectionHeader(title: 'Account')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            sliver: SliverToBoxAdapter(
              child: ProfileTile(
                icon: Icons.logout_rounded,
                iconColor: AppColors.error,
                title: 'Log Out',
                subtitle: 'Sign out of your QuickBite account',
                isDestructive: true,
                onTap: () {
                  HapticFeedback.vibrate();
                  _showLogoutDialog(context, ref);
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxl)),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: const Text('Log Out', style: AppTextStyles.headlineSmall),
        content: const Text(
          'Are you sure you want to sign out of QuickBite?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel', style: AppTextStyles.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.medium,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log Out', style: AppTextStyles.labelLarge),
          ),
        ],
      ),
    );

    if (isConfirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).signOut();
    }
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.xs,
      ),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
