import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_shadows.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.data,
    this.bottom,
    this.top,
    this.height,
    this.width,
    this.mainContainerAlignment = .start,
    this.showDifficulty = false,
  });
  final double? bottom;
  final Recipe data;
  final double? top;
  final double? height;
  final double? width;
  final MainAxisAlignment mainContainerAlignment;
  final bool showDifficulty;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // recipeBottomSheet(context);
        context.pushNamed(AppRoutes.recipeDetail, extra: data);
      },
      child: Container(
        height: height ?? 380,
        width: width ?? 260,
        margin: AppInsets.card,
        child: Stack(
          alignment: .center,
          clipBehavior: .none,
          children: [
            //main stack container
            Container(
              padding: AppInsets.lg,
              width: (width ?? 250) - 10,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.large,
                boxShadow: AppShadows.cardShadow,
              ),
              child: Column(
                mainAxisAlignment: mainContainerAlignment,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    data.name ?? 'Missing Name',
                    style: AppTextStyles.headlineMedium,
                  ),
                  AppSpacing.vXxl,
                  showDifficulty
                      ? Container(
                          padding: AppInsets.hSm,
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.large,
                            color: AppColors.primary,
                          ),
                          child: Text(
                            '${data.difficulty}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            //stacked food image
            Positioned(
              bottom: bottom ?? -50,
              left: 0,
              right: 0,
              top: top ?? 60,
              child: Container(
                // clipBehavior: .none,
                padding: AppInsets.xxl,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(-4, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(4, -4),
                    ),
                  ],
                ),
                child: Container(
                  // clipBehavior: .none,
                  padding: AppInsets.card,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.background,
                    image: DecorationImage(
                      image: NetworkImage(data.image ?? ''),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //   void recipeBottomSheet(BuildContext context) {
  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       useSafeArea: true,
  //       clipBehavior: Clip.hardEdge,
  //       builder: (context) {
  //         return DraggableScrollableSheet(
  //           initialChildSize: 0.5,
  //           minChildSize: 0.2,
  //           maxChildSize: 0.9,
  //           expand: false,
  //           builder: (context, scrollController) {
  //             return CustomScrollView(
  //               controller: scrollController,
  //               slivers: [
  //                 SliverPadding(
  //                   padding: AppInsets.lg,
  //                   sliver: SliverToBoxAdapter(
  //                     child: Text(
  //                       'data' * 10000,
  //                       style: AppTextStyles.headlineMedium,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       },
  //     );
  //   }
}
