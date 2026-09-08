import 'package:flutter/foundation.dart';

@immutable
class Recipe {
  final String? id;
  final String? name;
  final List<String>? ingredients;
  final List<String>? instructions;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final String? difficulty;
  final String? cuisine;
  final int? caloriesPerServing;
  final List<String>? tags;
  final String? userId;
  final String? image;
  final double? rating;
  final int? reviewCount;
  final List<String>? mealType;
  final bool isApproved;

  const Recipe({
    this.id,
    this.name,
    this.ingredients,
    this.instructions,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.difficulty,
    this.cuisine,
    this.caloriesPerServing,
    this.tags,
    this.userId,
    this.image,
    this.rating,
    this.reviewCount,
    this.mealType,
    this.isApproved = false,
  });
}