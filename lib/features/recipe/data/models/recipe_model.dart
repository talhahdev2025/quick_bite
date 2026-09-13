// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class RecipeModel {
  final String? id; // Changed from int? to String? for Firestore/UUID compatibility
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
  final String? userId; // Changed from int? to String? for Firebase UID compatibility
  final String? image;
  final double? rating;
  final int? reviewCount;
  final List<String>? mealType;
  final String status;
  final String? rejectionReason;

  const RecipeModel({
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

  RecipeModel copyWith({
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
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id?.toString(),
      name: recipe.name,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      prepTimeMinutes: recipe.prepTimeMinutes,
      cookTimeMinutes: recipe.cookTimeMinutes,
      servings: recipe.servings,
      difficulty: recipe.difficulty,
      cuisine: recipe.cuisine,
      caloriesPerServing: recipe.caloriesPerServing,
      tags: recipe.tags,
      userId: recipe.userId?.toString(),
      image: recipe.image,
      rating: recipe.rating,
      reviewCount: recipe.reviewCount,
      mealType: recipe.mealType,
      status: recipe.status,
      rejectionReason: recipe.rejectionReason,
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
      status: status,
      rejectionReason: rejectionReason,
    );
  }

  Map<String, dynamic> toMapForSQFLite() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ingredients': ingredients != null ? jsonEncode(ingredients) : null,
      'instructions': instructions != null ? jsonEncode(instructions) : null,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'cuisine': cuisine,
      'caloriesPerServing': caloriesPerServing,
      'tags': tags != null ? jsonEncode(tags) : null,
      'userId': userId,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'mealType': mealType != null ? jsonEncode(mealType) : null,
      'status': status,
      'rejectionReason': rejectionReason,
    };
  }

  factory RecipeModel.fromMapForSQFLite(Map<String, dynamic> map) {
    List<String>? parseList(dynamic data) {
      if (data == null) return null;
      if (data is String) {
        final decoded = jsonDecode(data);
        return List<String>.from(decoded as List);
      }
      if (data is List) {
        return List<String>.from(data);
      }
      return null;
    }

    return RecipeModel(
      id: map['id']?.toString(),
      name: map['name'] as String?,
      ingredients: parseList(map['ingredients']),
      instructions: parseList(map['instructions']),
      prepTimeMinutes: map['prepTimeMinutes'] as int?,
      cookTimeMinutes: map['cookTimeMinutes'] as int?,
      servings: map['servings'] as int?,
      difficulty: map['difficulty'] as String?,
      cuisine: map['cuisine'] as String?,
      caloriesPerServing: map['caloriesPerServing'] as int?,
      tags: parseList(map['tags']),
      userId: map['userId']?.toString(),
      image: map['image'] as String?,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      reviewCount: map['reviewCount'] as int?,
      mealType: parseList(map['mealType']),
      status: map['status'] as String? ?? 'pending',
      rejectionReason: map['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
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
      'status': status,
      'rejectionReason': rejectionReason,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    List<String>? parseStringList(dynamic data) {
      if (data == null) return null;
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      if (data is String) {
        final dynamic decoded = jsonDecode(data);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      }
      return null;
    }

    return RecipeModel(
      id: docId ?? map['id']?.toString(),
      name: map['name'] as String?,
      ingredients: parseStringList(map['ingredients']),
      instructions: parseStringList(map['instructions']),
      prepTimeMinutes: map['prepTimeMinutes'] as int?,
      cookTimeMinutes: map['cookTimeMinutes'] as int?,
      servings: map['servings'] as int?,
      difficulty: map['difficulty'] as String?,
      cuisine: map['cuisine'] as String?,
      caloriesPerServing: map['caloriesPerServing'] as int?,
      tags: parseStringList(map['tags']),
      userId: map['userId']?.toString(),
      image: map['image'] as String?,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      reviewCount: map['reviewCount'] as int?,
      mealType: parseStringList(map['mealType']),
      status: map['status'] as String? ?? 'pending',
      rejectionReason: map['rejectionReason'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(Map<String, dynamic> map) => RecipeModel.fromMap(map);

  factory RecipeModel.fromJsonString(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipeModel(id: $id, name: $name, ingredients: $ingredients, instructions: $instructions, prepTimeMinutes: $prepTimeMinutes, cookTimeMinutes: $cookTimeMinutes, servings: $servings, difficulty: $difficulty, cuisine: $cuisine, caloriesPerServing: $caloriesPerServing, tags: $tags, userId: $userId, image: $image, rating: $rating, reviewCount: $reviewCount, mealType: $mealType, status: $status, rejectionReason: $rejectionReason)';
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