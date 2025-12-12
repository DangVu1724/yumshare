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

  final double cookingTime;
  final int servingPeople;

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
    required this.cookingTime,
    required this.servingPeople,
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
    double? cookingTime,
    int? servingPeople,
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
      cookingTime: cookingTime ?? this.cookingTime,
      servingPeople: servingPeople ?? this.servingPeople,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      'cookingTime': cookingTime,
      'servingPeople': servingPeople,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      authorId: map['authorId'] ?? '',
      originalId: map['originalId'],
      isShared: map['isShared'] ?? false,
      ingredients: (map['ingredients'] as List? ?? []).map((x) => Ingredients.fromMap(x)).toList(),
      steps: (map['steps'] as List? ?? []).map((x) => RecipeStep.fromMap(x)).toList(),
      imageUrl: map['imageUrl'],
      likes: map['likes'] ?? 0,
      rating: (map['rating'] ?? 0).toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
      description: map['description'] ?? '',
      regions: map['regions'] ?? '',
      category: map['category'] ?? '',
      cookingTime: (map['cookingTime'] ?? 0).toDouble(),
      servingPeople: map['servingPeople'] ?? 1,
      updatedAt: _parseDate(map['updatedAt']),
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  String toJson() => json.encode(toMap());
  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}
