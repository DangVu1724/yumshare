import 'package:hive/hive.dart';
import 'package:yumshare/models/recipes.dart';

part 'recipe_hive.g.dart';

@HiveType(typeId: 1)
class RecipeFeedHive {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String authorId;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String regions;

  @HiveField(6)
  final bool isShared;

  @HiveField(7)
  final int likesCount;

  @HiveField(8)
  final double rating;

  @HiveField(9)
  final int ratingCount;

  @HiveField(10)
  final DateTime createdAt;

  RecipeFeedHive({
    required this.id,
    required this.name,
    required this.authorId,
    this.imageUrl,
    required this.category,
    required this.regions,
    required this.isShared,
    required this.likesCount,
    required this.rating,
    required this.ratingCount,
    required this.createdAt,
  });

  /// Firestore → Hive
  factory RecipeFeedHive.fromRecipe(Recipe r) {
    return RecipeFeedHive(
      id: r.id,
      name: r.name,
      authorId: r.authorId,
      imageUrl: r.imageUrl,
      category: r.category,
      regions: r.regions,
      isShared: r.isShared,
      likesCount: r.likesCount,
      rating: r.rating,
      ratingCount: r.ratingCount,
      createdAt: r.createdAt,
    );
  }

  /// Hive → UI Recipe (bản nhẹ)
  Recipe toRecipe() {
    return Recipe(
      id: id,
      name: name,
      authorId: authorId,
      imageUrl: imageUrl,
      category: category,
      regions: regions,
      isShared: isShared,
      likesCount: likesCount,
      rating: rating,
      ratingCount: ratingCount,
      description: '',
      ingredients: const [],
      steps: const [],
      cookingTime: 0,
      servingPeople: 0,
      createdAt: createdAt,
    );
  }
}
