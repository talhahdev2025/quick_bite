import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/app.dart';
import 'package:quick_bite/core/widgets/custom_filled_button.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';

void main() {
  group('QuickBite Unit & Widget Tests', () {
    test('RecipeModel parses JSON accurately', () {
      final json = {
        'id': 1,
        'name': 'Classic Margherita Pizza',
        'ingredients': ['Pizza dough', 'Tomato sauce', 'Fresh mozzarella'],
        'instructions': ['Roll dough', 'Add sauce and cheese', 'Bake at 450F'],
        'prepTimeMinutes': 20,
        'cookTimeMinutes': 15,
        'servings': 4,
        'difficulty': 'Easy',
        'cuisine': 'Italian',
        'caloriesPerServing': 300,
        'tags': ['Pizza', 'Italian'],
        'image': 'https://cdn.dummyjson.com/recipe-images/1.webp',
        'rating': 4.6,
        'reviewCount': 98,
        'mealType': ['Dinner'],
      };

      final model = RecipeModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Classic Margherita Pizza');
      expect(model.ingredients?.length, 3);
      expect(model.difficulty, 'Easy');

      final entity = model.toEntity();
      expect(entity.id, 1);
      expect(entity.name, 'Classic Margherita Pizza');

      final sqfLiteMap = model.toMapForSQFLite();
      expect(sqfLiteMap['id'], 1);
      expect(sqfLiteMap['name'], 'Classic Margherita Pizza');
    });

    testWidgets('CustomFilledButton renders text and responds to taps', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFilledButton(
              title: 'Continue',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(tapped, isTrue);
    });

    testWidgets('CustomFilledButton displays loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFilledButton(
              title: 'Continue',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
    });

    testWidgets('QuickBite app smoke test', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: QuickBite(),
        ),
      );

      await tester.pump();
      expect(find.byType(QuickBite), findsOneWidget);
    });
  });
}

