import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/home/presentation/provider/providers.dart';
import 'package:quick_bite/features/home/presentation/widgets/home_card.dart';

class RecipiesListViewWidget extends ConsumerWidget {
  const RecipiesListViewWidget({super.key, required this.scrollDirection});
  final Axis scrollDirection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipeProvider);
    return recipesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(recipeProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
      data: (data) {
        return ListView.builder(
          scrollDirection: scrollDirection,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final recipe = data[index];
            return Center(child: HomeCard(data: recipe));
          },
        );
      },
    );
  }
}
