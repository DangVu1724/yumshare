import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/models/ingredients.dart';
import 'package:yumshare/models/recipte_step.dart';

class Recipe {
  final String id;
  final String name;
  final String authorId;
  final String? originalId;
  final bool isShared;
  final List<Ingredients> ingredients;
  final List<RecipeStep> steps;
  final String? imageUrl;
  final int likes;
  final String description;
  final String regions;
  final String category;
  final DateTime updatedAt;
  final DateTime createdAt;

  final double rating;
  final int ratingCount;

  Recipe({
    required this.id,
    required this.name,
    required this.authorId,
    this.originalId,
    required this.isShared,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.likes = 0,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.description,
    required this.regions,
    required this.category,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  double get popularScore {
    return (likes * 2) + (rating * ratingCount * 2) + ratingCount;
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? authorId,
    String? originalId,
    bool? isShared,
    List<Ingredients>? ingredients,
    List<RecipeStep>? steps,
    String? imageUrl,
    int? likes,
    double? rating,
    int? ratingCount,
    String? description,
    String? regions,
    String? category,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      authorId: authorId ?? this.authorId,
      originalId: originalId ?? this.originalId,
      isShared: isShared ?? this.isShared,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      description: description ?? this.description,
      regions: regions ?? this.regions,
      category: category ?? this.category,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'authorId': authorId,
      'originalId': originalId,
      'isShared': isShared,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'steps': steps.map((x) => x.toMap()).toList(),
      'imageUrl': imageUrl,
      'likes': likes,
      'rating': rating,
      'ratingCount': ratingCount,
      'description': description,
      'regions': regions,
      'category': category,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      authorId: map['authorId'] ?? '',
      originalId: map['originalId'], // nullable thì giữ nguyên
      isShared: map['isShared'] ?? false,

      ingredients: (map['ingredients'] as List<dynamic>? ?? [])
          .map((x) => Ingredients.fromMap(x as Map<String, dynamic>))
          .toList(),

      steps: (map['steps'] as List<dynamic>? ?? []).map((x) => RecipeStep.fromMap(x as Map<String, dynamic>)).toList(),

      imageUrl: map['imageUrl'], 

      likes: (map['likes'] ?? 0) as int,

      rating: (map['rating'] ?? 0).toDouble(),
      ratingCount: (map['ratingCount'] ?? 0) as int,

      description: map['description'] ?? '',
      regions: map['regions'] ?? '',
      category: map['category'] ?? '',

      updatedAt: _parseDate(map['updatedAt']),
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source) as Map<String, dynamic>);
}
