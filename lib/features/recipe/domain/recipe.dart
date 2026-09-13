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
  final String status; // 'pending', 'approved', or 'rejected'
  final String? rejectionReason;

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
    this.status = 'pending',
    this.rejectionReason,
  });

  Recipe copyWith({
    String? id,
    String? name,
    List<String>? ingredients,
    List<String>? instructions,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? servings,
    String? difficulty,
    String? cuisine,
    int? caloriesPerServing,
    List<String>? tags,
    String? userId,
    String? image,
    double? rating,
    int? reviewCount,
    List<String>? mealType,
    String? status,
    String? rejectionReason,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      cuisine: cuisine ?? this.cuisine,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      mealType: mealType ?? this.mealType,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recipe &&
        other.id == id &&
        other.name == name &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.instructions, instructions) &&
        other.prepTimeMinutes == prepTimeMinutes &&
        other.cookTimeMinutes == cookTimeMinutes &&
        other.servings == servings &&
        other.difficulty == difficulty &&
        other.cuisine == cuisine &&
        other.caloriesPerServing == caloriesPerServing &&
        listEquals(other.tags, tags) &&
        other.userId == userId &&
        other.image == image &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        listEquals(other.mealType, mealType) &&
        other.status == status &&
        other.rejectionReason == rejectionReason;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      Object.hashAll(ingredients ?? []),
      Object.hashAll(instructions ?? []),
      prepTimeMinutes,
      cookTimeMinutes,
      servings,
      difficulty,
      cuisine,
      caloriesPerServing,
      Object.hashAll(tags ?? []),
      userId,
      image,
      rating,
      reviewCount,
      Object.hashAll(mealType ?? []),
      status,
      rejectionReason,
    );
  }
}