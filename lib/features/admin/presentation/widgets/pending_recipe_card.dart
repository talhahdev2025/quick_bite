import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart'; // Adjust path if needed

class PendingRecipeCard extends ConsumerWidget {
  final Recipe recipe;
  final VoidCallback? onViewRecipe;

  const PendingRecipeCard({
    super.key,
    required this.recipe,
    this.onViewRecipe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row: Recipe Image + Name
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: recipe.image != null && recipe.image!.isNotEmpty
                      ? Image.network(
                          recipe.image!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImagePlaceholder(theme),
                        )
                      : _buildImagePlaceholder(theme),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    recipe.name ?? 'Untitled Recipe',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Metadata: Author & Cuisine
            if (recipe.userId != null) ...[
              Text(
                'Submitted by: ${recipe.userId}', // Replace with user name if available
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4.0),
            ],
            if (recipe.cuisine != null) ...[
              Text(
                'Category: ${recipe.cuisine}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12.0),
            ],

            // View Recipe Full Width Action Button
            OutlinedButton.icon(
              onPressed: onViewRecipe ?? () {
                // Navigate to details screen, e.g. context.push('/recipe/${recipe.id}');
              },
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('View Recipe'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Decision Buttons: Reject vs Approve
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleReject(context, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleApprove(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      color: theme.colorScheme.surfaceContainerHigh,
      child: const Center(
        child: Text('🍛', style: TextStyle(fontSize: 28)),
      ),
    );
  }

  void _handleApprove(BuildContext context, WidgetRef ref) {
    if (recipe.id == null) return;
    // Example: ref.read(adminControllerProvider.notifier).approveRecipe(recipe.id!);
  }

  void _handleReject(BuildContext context, WidgetRef ref) {
    if (recipe.id == null) return;
    // Example: ref.read(adminControllerProvider.notifier).rejectRecipe(recipe.id!);
  }
}