import 'package:yumshare/models/ingredients.dart';
import 'package:yumshare/models/recipte_step.dart';

class Recipe {
  final String id;
  final String name;
  final String authorId; // user tạo
  final String? originalId; // nếu là bản sao, lưu id công thức gốc
  final bool isShared; // true nếu chia sẻ lên cộng đồng
  final List<Ingredients> ingredients;
  final List<RecipeStep> steps;
  final String? imageUrl;
  final int likes;
  final String description;
  final String category;
  final DateTime updatedAt;
  final DateTime createdAt;

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
    DateTime? createdAt,
    required this.description,
    required this.category,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now() ,
       updatedAt = updatedAt ?? DateTime.now();
}
