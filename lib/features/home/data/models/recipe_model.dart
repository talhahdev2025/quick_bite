// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class RecipeModel {
  int? id;
  String? name;
  List<String>? ingredients;
  List<String>? instructions;
  int? prepTimeMinutes;
  int? cookTimeMinutes;
  int? servings;
  String? difficulty;
  String? cuisine;
  int? caloriesPerServing;
  List<String>? tags;
  int? userId;
  String? image;
  double? rating;
  int? reviewCount;
  List<String>? mealType;
  RecipeModel({
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
  });

  RecipeModel copyWith({
    int? id,
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
    int? userId,
    String? image,
    double? rating,
    int? reviewCount,
    List<String>? mealType,
  }) {
    return RecipeModel(
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
    );
  }

  Recipe toEntity() {
    return Recipe(
      id: id,
      name: name,
      ingredients: ingredients,
      instructions: instructions,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      difficulty: difficulty,
      cuisine: cuisine,
      caloriesPerServing: caloriesPerServing,
      tags: tags,
      userId: userId,
      image: image,
      rating: rating,
      reviewCount: reviewCount,
      mealType: mealType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'cuisine': cuisine,
      'caloriesPerServing': caloriesPerServing,
      'tags': tags,
      'userId': userId,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'mealType': mealType,
    };
  }
//
factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String?,
      ingredients: map['ingredients'] != null
          ? List<String>.from(map['ingredients'])
          : null,
      instructions: map['instructions'] != null
          ? List<String>.from(map['instructions'])
          : null,
      prepTimeMinutes: map['prepTimeMinutes'] != null
          ? map['prepTimeMinutes'] as int
          : null,
      cookTimeMinutes: map['cookTimeMinutes'] != null
          ? map['cookTimeMinutes'] as int
          : null,
      servings: map['servings'] != null ? map['servings'] as int : null,
      difficulty: map['difficulty'] as String?,
      cuisine: map['cuisine'] as String?,
      caloriesPerServing: map['caloriesPerServing'] != null
          ? map['caloriesPerServing'] as int
          : null,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      image: map['image'] as String?,
      rating: map['rating'] != null
          ? (map['rating'] as num).toDouble()
          : null,
      reviewCount: map['reviewCount'] != null
          ? map['reviewCount'] as int
          : null,
      mealType: map['mealType'] != null
          ? List<String>.from(map['mealType'])
          : null,
    );
  }
//

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Recipes(id: $id, name: $name, ingredients: $ingredients, instructions: $instructions, prepTimeMinutes: $prepTimeMinutes, cookTimeMinutes: $cookTimeMinutes, servings: $servings, difficulty: $difficulty, cuisine: $cuisine, caloriesPerServing: $caloriesPerServing, tags: $tags, userId: $userId, image: $image, rating: $rating, reviewCount: $reviewCount, mealType: $mealType)';
  }

  @override
  bool operator ==(covariant RecipeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
        listEquals(other.mealType, mealType);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        ingredients.hashCode ^
        instructions.hashCode ^
        prepTimeMinutes.hashCode ^
        cookTimeMinutes.hashCode ^
        servings.hashCode ^
        difficulty.hashCode ^
        cuisine.hashCode ^
        caloriesPerServing.hashCode ^
        tags.hashCode ^
        userId.hashCode ^
        image.hashCode ^
        rating.hashCode ^
        reviewCount.hashCode ^
        mealType.hashCode;
  }
}
