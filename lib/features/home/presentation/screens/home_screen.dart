// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:quick_bite/core/constants/app_colors.dart';
// import 'package:quick_bite/core/constants/app_insets.dart';
// import 'package:quick_bite/core/constants/app_radius.dart';
// import 'package:quick_bite/core/constants/app_sizes.dart';
// import 'package:quick_bite/core/constants/app_spacing.dart';
// import 'package:quick_bite/core/constants/app_text_styles.dart';
// import 'package:quick_bite/features/home/presentation/provider/providers.dart';
// import 'package:quick_bite/features/home/presentation/widgets/home_card.dart';
// import 'package:quick_bite/features/home/presentation/widgets/home_card1.dart';
// import 'package:quick_bite/features/home/presentation/widgets/recipies_listview_widget.dart';
// import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool isVerticalList = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: CustomScrollView(
//           // crossAxisAlignment: .start,
//           slivers: [
//             SliverToBoxAdapter(
//               child: Container(
//                 // color: Colors.amber,
//                 height: MediaQuery.heightOf(context) * 0.3,
//                 padding: AppInsets.hXl,
//                 child: Column(
//                   crossAxisAlignment: .start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: .end,
//                       children: [
//                         Consumer(
//                           builder: (context, ref, child) {
//                             final authState = ref.watch(authProvider);
//                             return IconButton(
//                               onPressed: authState.isLoading
//                                   ? null
//                                   : () => ref
//                                         .read(authProvider.notifier)
//                                         .signOut(),
//                               icon: authState.isLoading
//                                   ? const SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                       ),
//                                     )
//                                   : const Icon(Icons.logout_rounded),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     Text(
//                       'Delicious\nRecipes for you',
//                       style: TextStyle(fontSize: 42, fontWeight: .bold),
//                     ),
//                     AppSpacing.vXl,
//                     //search text field
//                     TextField(
//                       decoration: InputDecoration(
//                         hint: Text(
//                           'search',
//                           style: AppTextStyles.bodyLarge.copyWith(
//                             color: AppColors.textHint,
//                           ),
//                         ),
//                         prefixIcon: Icon(Icons.search_rounded),
//                         filled: true,
//                         fillColor: AppColors.background,
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: .none,
//                           borderRadius: AppRadius.xLarge,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.primary),
//                           borderRadius: AppRadius.xLarge,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             //list view
//             // Spacer(),
//             SliverToBoxAdapter(
//               child: Container(
//                 // color: Colors.brown,
//                 height: MediaQuery.heightOf(context) * 0.05,
//                 padding: AppInsets.hXl,
//                 child: Row(
//                   mainAxisAlignment: .spaceBetween,
//                   children: [
//                     Text('Recipes', style: AppTextStyles.headlineMedium),
//                     IconButton(
//                       icon: Icon(Icons.list_rounded, size: 25),
//                       onPressed: () => setState(() {
//                         isVerticalList = !isVerticalList;
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Spacer
//             Consumer(
//               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                 return ref
//                     .watch(recipeProvider)
//                     .when(
//                       loading: () => SliverToBoxAdapter(
//                         child: Center(child: CircularProgressIndicator()),
//                       ),
//                       error: (error, stackTrace) {
//                         return SliverToBoxAdapter(
//                           child: Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   error.toString(),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     ref.invalidate(recipeProvider);
//                                   },
//                                   child: const Text('Retry'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       data: (data) {
//                         return SliverGrid.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 1,
//                                 mainAxisSpacing: AppSizes.xxxl,
//                               ),
//                           itemCount: data.length,
//                           itemBuilder: (context, index) {
//                             final recipe = data[index];
//                             return Center(child: HomeCard1(data: recipe));
//                           },
//                         );
//                       },
//                     );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/home/presentation/provider/providers.dart';
import 'package:quick_bite/features/home/presentation/widgets/recipe_detail_card.dart';
import 'package:quick_bite/features/home/presentation/widgets/home_card.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Toggle between 1 column and 2 columns
  bool isGridMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top Header & Search Section
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.hXl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final authState = ref.watch(authProvider);
                            return IconButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : () => ref
                                        .read(authProvider.notifier)
                                        .signOut(),
                              icon: authState.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.logout_rounded),
                            );
                          },
                        ),
                      ],
                    ),
                    const Text(
                      'Delicious\nRecipes for you',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),
                    AppSpacing.vXl,
                    // Search Text Field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textHint,
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: AppColors.background,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: AppRadius.xLarge,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: AppRadius.xLarge,
                        ),
                      ),
                    ),
                    AppSpacing.vLg,
                  ],
                ),
              ),
            ),

            // Recipes Section Header & Layout Toggle
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.hXl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recipes', style: AppTextStyles.headlineMedium),
                    IconButton(
                      icon: Icon(
                        isGridMode
                            ? Icons.view_agenda_outlined
                            : Icons.grid_view_rounded,
                        size: 24,
                      ),
                      onPressed: () => setState(() {
                        isGridMode = !isGridMode;
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Recipe Grid/List View
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return ref
                    .watch(recipeProvider)
                    .when(
                      loading: () => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stackTrace) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  error.toString(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.invalidate(recipeProvider);
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      data: (data) {
                        return SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isGridMode ? 2 : 1,
                                // mainAxisSpacing: 16,
                                // crossAxisSpacing: 16,
                                childAspectRatio: isGridMode ? 0.62 : 1.2,
                              ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final recipe = data[index];
                            return HomeCard(
                              data: recipe,
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                        );
                      },
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
