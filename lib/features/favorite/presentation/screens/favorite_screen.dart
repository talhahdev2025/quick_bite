// import 'package:flutter/material.dart';
// import 'package:quick_bite/core/constants/app_colors.dart';
// import 'package:quick_bite/core/constants/app_insets.dart';
// import 'package:quick_bite/core/constants/app_radius.dart';
// import 'package:quick_bite/core/constants/app_sizes.dart';
// import 'package:quick_bite/core/constants/app_spacing.dart';
// import 'package:quick_bite/core/constants/app_text_styles.dart';

// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({super.key});

//   @override
//   State<FavoriteScreen> createState() => _FavoriteScreenState();
// }

// class _FavoriteScreenState extends State<FavoriteScreen> {
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
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             // horizontal: AppSizes.xxxl,
//             vertical: AppSizes.xl,
//           ),
//           child: Column(
//             crossAxisAlignment: .start,
//             children: [
//               Padding(
//                 padding: AppInsets.hXl,
//                 child: Wrap(
//                   children: [
//                     Row(
//                       mainAxisAlignment: .end,
//                       children: [
//                         IconButton(
//                           onPressed: () {},
//                           icon: Icon(Icons.shopping_cart_outlined),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       'Delicious\nfood for you',
//                       style: AppTextStyles.displayLarge,
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
//               Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/favorite/presentation/providers/providers.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the AsyncValue state from the favoriteNotifierProvider
    final favoriteState = ref.watch(favoriteNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(favoriteNotifierProvider.notifier).build(),
          ),
        ],
      ),
      body: favoriteState.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites added yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemBuilder: (context, index) {
              final recipe = favorites[index];

              return Dismissible(
                key: Key(recipe.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  // Toggle favorite removes it from SQLite & updates UI state
                  ref
                      .read(favoriteNotifierProvider.notifier)
                      .toggleFavorite(recipe);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${recipe.name} removed from favorites'),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        recipe.image.toString(),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood, size: 40),
                      ),
                    ),
                    title: Text(
                      recipe.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text('\$${recipe..toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(favoriteNotifierProvider.notifier)
                            .toggleFavorite(recipe);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Failed to load favorites: $error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(favoriteNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
